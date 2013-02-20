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
            @defense = params.defense || 0
            @attack = params.attack || 1
            #percent chance to dodge attack (0 to 100)
            @dodge = params.dodge || 0

    return Combat
)
