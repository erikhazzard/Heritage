#============================================================================
#
#Renderer component
#   Defines visible rendered properties
#
#   Dependencies / Coupling:
#       -entity: position
#
#============================================================================
define([], ()->
    class Renderer
        constructor: (entity)->
            @entity = entity
            @color = 'rgba(0,0,0,0.5)'
            @x = @y = 0

            @size = 10

            return @
        
        setColor: (color)->
            @color = color
            
        setSize: (size)->
            @size = size

        getPosition: ()->
            @x = @entity.components.position.x
            @y = @entity.components.position.y
            
            return {x: @x, y: @y}
            
    return Renderer
)
