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

            @range = params.range || 4
            @defense = params.defense || 0
            @attack = params.attack || 1
            #percent chance to dodge attack (0 to 100)
            @dodge = params.dodge || 0
            
            #must wait n rounds before attacking again
            @attackDelay = 10

            #how many ticks before entity can attack again
            @attackCounter = 0
            @canAttack = true
            #ID of target entity
            @target = null
            #Keep track of any damage done (per tick)
            @damageTaken = []

    return Combat
)
