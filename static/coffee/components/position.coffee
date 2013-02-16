#============================================================================
#
#Position component
#   Defines position
#
#============================================================================
define(['components/vector'], (Vector)->
    class Position extends Vector
        constructor: (entity, params)->
            params = params || {}
            
            @entity = entity
            @x = params.x || 0
            @y = params.y || 0
            return @
            
    return Position
)
