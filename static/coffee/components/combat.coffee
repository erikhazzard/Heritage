#============================================================================
#
#Combat
#   Combat related data. e.g., range
#   TODO: Range could be increased with weapons
#   NOTE: Not all entities may have this component. for example, very young
#   human entities may not have it
#
#============================================================================
define([], ()->
    class Combat
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            @range = params.range || 1
            
    return Combat
)
