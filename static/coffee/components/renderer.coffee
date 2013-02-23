#============================================================================
#
#Renderer component
#   Defines visible rendered properties
#
#   Dependencies / Coupling:
#       -entity: position
#
#============================================================================
define(['components/world'], (World)->
    class Renderer
        constructor: (entity)->
            @entity = entity
            @color = 'rgba(0,0,0,0.7)'

            #@size = World.cellSize
            @size = 10

            return @
        
        setColor: (color)->
            @color = color
            
        setSize: (size)->
            @size = size
            
    return Renderer
)
