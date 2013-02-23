#============================================================================
#
#Health
#   Health component. Defines health of an entity
#
#============================================================================
define([], ()->
    class Health
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            @health = params.health || 100
            @maxHealth = params.maxHealth || @health
            
            return @
            
    return Health
)
