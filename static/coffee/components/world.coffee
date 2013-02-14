#============================================================================
#
#World component
#   Defines the world the entities live on. 
#       Namely, the width / height of the world and the canvas context
#
#   TODO: Should this be something, or maybe live somewhere else? Lots of
#   coupling going on here
#
#   Dependencies / Coupling:
#       entity
#
#============================================================================
define([], ()->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    
    class World
        @width = 500
        @height = 500
        @canvas = canvas
        @context = context

        constructor: (entity, params)->
            #By default, we'll use the passed in canvas above.
            #  Keep in mind extensibility though, as we may want
            #  to have multiple 'worlds'
            params = params || {}
            @entity = entity
            @width = params.width || World.width
            @height = params.height || World.width
            @canvas = params.canvas || World.canvas
            @context = params.context || World.context
            
            #World config
            return @
    
    return World
)
