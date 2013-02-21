#============================================================================
#
#Resources component
#   Defines resources component
#
#   Resources here is just a number, but might mean different things
#     for different entities types (implemented in systems)
#
#============================================================================
define([], ()->
    class Resources
        constructor: (entity, params)->
            @entity = entity
            params = params || {}
            @resources = params.resources || 100

    return Resources
)
