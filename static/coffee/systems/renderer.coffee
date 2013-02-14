#============================================================================
#
#Systems - Renderer
#   Controls the renderer
#
#   Requires: Entities, for each entity will look at the renderer component
#   and draw to the canvas based on it
#
#============================================================================
define(['components/world'], (World)->
    canvas = World.canvas
    context = World.context
    
    class World
        constructor: (entities)->
            @entities = entities
            return @
            
        tick: (delta)=>
            #Redraw the canvas
            canvas.width = canvas.width
            
            #Renders to the canvas. Ideally, we'd use events here
            for id, entity of @entities.entitiesIndex['renderer']
                context.save()
                
                #Get the position to render to
                renderPosition = entity.components.renderer.getPosition()

                #Setup the canvas
                context.fillStyle = entity.components.renderer.color
                context.fillRect(
                    renderPosition.x,
                    renderPosition.y,
                    entity.components.renderer.size,
                    entity.components.renderer.size
                )
                
                #if there is an image, draw the image
                context.restore()
            
            return @
    
    return World
)
