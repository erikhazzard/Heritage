#============================================================================
#
#Systems - Zombie
#   Handles logic to keep a zombie 'alive' - updates it each tick
#
#   components used:
#       physics
#
#   Zombie overview: 
#       Does not naturally lose health, regardless of amount of resources
#       If resources is 0, they won't fall below 0 but will slow down the 
#       zombie's movement and attack / defense until it feeds on a human
#       Does not naturally regain health either
#============================================================================
define(['entity', 'assemblages/assemblages'], (Entity, Assemblages)->
    class Zombie
        @ageSpeed = 0.05
        constructor: (entities)->
            @entities = entities
            return @

        #Helpers
        #--------------------------------
        calculateResources: (entity)->
            resources = entity.components.resources.resources
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            #Resources decay naturally
            if resources > 0
                resources -= (entity.components.zombie.decayRate)
            resources += @updateResourcesFromCombat(entity)

            return resources
        
        updateResourcesFromCombat: (entity)->
            #Update resources if entity did damage
            combat = entity.components.combat
            if not combat
                return 0
            
            resources = 0
            if combat.damageDealt.length > 0
                resources += (10 * combat.damageDealt.length)

            return resources

        calculateMaxSpeed: (entity)->
            #Returns max speed based on various factors
            physics = entity.components.physics
            maxSpeed = physics.maxSpeed
            resources = entity.components.resources
            if not resources
                return false

            if resources.resources < 10
                maxSpeed = physics.baseMaxSpeed / 2
            else if resources.resources < 20
                maxSpeed = physics.baseMaxSpeed / 1.3
            else if resources.resources > 100
                modifier = (resources.resources / 4) * 0.1
                maxSpeed = physics.baseMaxSpeed + (modifier) | 0
            else
                maxSpeed = physics.baseMaxSpeed
                
            return maxSpeed
        
        updateCombatComponent: (entity)->
            #Updats attack / defense based on resources
            combat = entity.components.combat
            resources = entity.components.resources
            if not resources
                return false

            if resources.resources < 10
                combat.attack = combat.baseAttack / 3
                combat.defense = combat.baseDefense / 3
            else if resources.resources < 20
                combat.attack = combat.baseAttack / 2
                combat.defense = combat.baseDefense / 2
            else if resources.resources > 100
                modifier = (resources.resources / 4) * 0.1
                combat.attack = combat.baseAttack + (modifier) | 0
                combat.defense = combat.baseDefense + (modifier) | 0
            else
                combat.attack = combat.baseAttack
                combat.defense = combat.baseDefense

            return true

        #--------------------------------
        #
        #Update Zombie 
        #
        #--------------------------------
        updateZombie: (entity)->
            zombie = entity.components.zombie
            physics = entity.components.physics
            health = entity.components.health
            resources = entity.components.resources
            combat = entity.components.combat
            
            #Update age
            #  NOTE: Age doesn't affect zombies in any way
            zombie.age += Zombie.ageSpeed
            
            #get attack / defense
            if combat
                #If entity dealt damage, increase resources
                @updateCombatComponent(entity)
                
            #update resources
            if resources
                resources.resources = @calculateResources(entity)
            #Get max speed
            if physics
                physics.maxSpeed = @calculateMaxSpeed(entity)

            #Update health
            if health
                zombie.isDead = zombie.getIsDead(health.health)
            
            #If the entity is dead, remove it
            #------------------------
            if zombie.isDead
                @entities.remove(entity)
            
            return true
    
        #--------------------------------
        #
        #tick
        #
        #--------------------------------
        tick: (delta)->
            for id, entity of @entities.entitiesIndex.zombie
                @updateZombie(entity)

            return @
        
    return Zombie
)
