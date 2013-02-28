#============================================================================
#
#Systems - Zombie
#   Handles logic to keep a zombie 'alive' - updates it each tick
#
#   components used:
#       physics
#
#   Zombie overview: 
#       If resources is 0, zombie's movement and attack / defense until it 
#       feeds on a human. Does not naturally regain health, damages to humans
#       regend health.
#       Loses health slowly when resources are depleted
#============================================================================
define(['entity', 'assemblages/assemblages'], (Entity, Assemblages)->
    class Zombie
        @ageSpeed = 0.05
        constructor: (entities)->
            @entities = entities
            return @

        #--------------------------------
        #Helpers
        #--------------------------------
        calculateResources: (entity)->
            resources = entity.components.resources.resources
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            #Resources decay naturally
            if resources > 0
                resources -= (entity.components.zombie.decayRate)
            
            if entity.components.combat
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
        
        #HEALTH
        #--------------------------------
        calculateHealth: (entity)->
            health = entity.components.health.health
            combat = entity.components.combat
            resources = entity.components.resources.resources
            
            if combat and combat.damageDealt.length > 0
                for damage in combat.damageDealt
                    health += damage[1] * 0.5 | 0
                    
            #Lower from resources
            if resources and resources < 1
                health -= 0.1

            return health

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
        
        #Combat
        #--------------------------------
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
                combat.defense = combat.baseDefense + (modifier / 4 | 0)
            else
                combat.attack = combat.baseAttack
                combat.defense = combat.baseDefense
                
            #The more neighbors, the more attack 
            if combat.neighbors and combat.neighbors.zombie
                combat.attack += combat.neighbors.zombie.length
                combat.defense += (combat.neighbors.zombie.length * 1.2)
                
            #The more human neighbors, the less defense
            if combat.neighbors and combat.neighbors.human
                combat.attack -= (combat.neighbors.human.length * 0.2)
                combat.defense -= (combat.neighbors.human.length * 1.2)

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
            
            neighbors = null
            #get attack / defense
            if combat
                #Update combat values based on resources
                @updateCombatComponent(entity)
                if combat.neighbors and combat.neighbors.zombie
                    neighbors = combat.neighbors.zombie
                
            #update resources
            if resources
                #update resources b
                resources.resources = @calculateResources(entity)
                
            #Update health based on preivously dealt damage
            if health
                #update health
                health.health = @calculateHealth(entity)

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
                
                #Transfer control to another zombie if this is a PC
                if entity.components.userMovable
                    #If there re neighbors, transfer control to one
                    if neighbors and neighbors.length > 0
                        @entities.PC = neighbors[0]
                        @entities.entities[neighbors[0]].addComponent('userMovable')
                    else

                        #Transfer control to random zombie
                        zombies = @entities.entitiesIndex.zombie
                        @entities.PC = zombies[Object.keys(zombies)[0]].id
                        zombies[Object.keys(zombies)[0]].addComponent('userMovable')
                    
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
