#============================================================================
#
#Renderer component
#   Defines visible rendered properties
#
#============================================================================
define([], ()->
    class Renderer
        constructor: (entity)->
            @entity = entity
            @color = 'rgba(0,0,0,0.5)'
            @size = 10
            return @
        
        setColor: (color)->
            @color = color
            
        setSize: (size)->
            @size = size
            
    return Renderer
)
