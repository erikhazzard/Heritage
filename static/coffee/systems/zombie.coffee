#============================================================================
#
#Systems - Zombie
#   Handles logic to keep a zombie 'alive' - updates it each tick
#
#   components used:
#       human
#       physics
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
            resources -= (entity.components.zombie.decayRate)

            return resources

        calculateHealth: (entity)->
            #Calculate current health based on resources
            resources = entity.components.resources.resources
            health = entity.components.health.health
            
            #Subtract health if resources are scarce
            #happens faster if negative resources
            if resources < 0
                health -= (0.4 + Math.abs(resources * 0.04) )
            #slow, natural decay
            else if resources < 20
                health -= (0.2 + Math.abs(resources * 0.01) )
            #if resources are high, more life
            else if resources > 50
                health += (0.005 + Math.abs(resources * 0.005) )

            return health

        calculateMaxSpeed: (entity)->
            #Returns max speed based on various factors
            maxSpeed = entity.components.physics.maxSpeed
            if entity.components.resourcesresources < 20
                maxSpeed = 2
                
            return maxSpeed

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
            
            #Update age
            #  NOTE: Age doesn't affect zombies in any way
            zombie.age += Zombie.ageSpeed
            
            physics.maxSpeed = @calculateMaxSpeed(entity)
            
            #update resources
            resources.resources = @calculateResources(entity)
            
            #Update health
            health.health = @calculateHealth(entity)
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
