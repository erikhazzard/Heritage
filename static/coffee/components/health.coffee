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
            
    return Health
)
