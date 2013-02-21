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
        
        #ZOMBIE 
        #--------------------------------
        updateZombie: (entity)->
            zombie = entity.components.zombie
            physics = entity.components.physics
            health = entity.components.health
            
            #Update age
            zombie.age += Zombie.ageSpeed
            
            physics.maxSpeed = zombie.getMaxSpeed()
            
            #update resources
            zombie.resources = zombie.calculateResources()
            
            #Update health
            health.health = zombie.calculateHealth(health.health)
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
            for id, entity of @entities.entitiesIndex['zombie']
                @updateZombie(entity)
            return @
        
    return Zombie
)
