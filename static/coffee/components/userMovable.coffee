#============================================================================
#
#UserMovable
#  This component stores data from user input
#
#============================================================================
define([], ()->
    class UserMovable
        constructor: (entity, params)->
            params = params || {}
            @entity = entity
            
    return UserMovable
)
