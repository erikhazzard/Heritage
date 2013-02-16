#============================================================================
#
#Create component
#   Base creature component.  Human, Zombie, etc. extend creature behavior
#
#   Dependencies / Coupling:
#
#============================================================================
define([], ()->
    class Creature
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            @health = params.health || 100
            @tickFunctions = []
            
            #energy - affects how fast entity can move
            #When health falls below 0, it's dead
            @isDead = false
            
        tick: (delta)->
            #During each tick, update properties based on current properties
            if @health < 0
                @isDead = true
            
            return @
            
    return Creature
)
