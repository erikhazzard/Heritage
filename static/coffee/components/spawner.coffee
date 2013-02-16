#============================================================================
#
#Spawn
#   Defines spawn component
#       Specifies rules for creating new entities
#
#   Dependencies / Coupling:
#       -entity: world
#
#============================================================================
define([], ()->
    class Spawner
        constructor: (entity, params)->
            params = params || {}
            @entity = entity
            @neighbors = []
            
            #energy - affects how fast entity can move
            #When health falls below 0, it's dead
            @isDead = false
            
        getNeighbors: ()->
            #Return neighbors for an entity
            @neighbors = @entity.components.world.neighbors
            
            return @neighbors
            
        tick: (delta)->
            #During each tick, update properties based on current properties
            #Update age
            @age += 0.2

            #update resources
            @resources = @calculateResources()
            
            #Update health
            @health = @calculateHealth()
            
            if @health < 0
                @isDead = true
            
            return @
            
    return Spawner
)
