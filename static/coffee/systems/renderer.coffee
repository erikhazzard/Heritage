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
    
    class Renderer
        constructor: (entities)->
            @entities = entities
            return @
            
        tick: (delta)=>
            #Redraw the canvas
            canvas.width = canvas.width
            
            #Renders to the canvas. Ideally, we'd use events here
            for id, entity of @entities.entitiesIndex['renderer']
                size = entity.components.renderer.size
                context.save()
                
                #Get the position to render to
                renderPosition = entity.components.renderer.getPosition()

                #Setup the canvas
                context.fillStyle = entity.components.renderer.color
                
                if entity.components.human
                    alpha = Math.round( (1-(entity.components.human.age / 110)) * 10 ) / 10
                    if entity.components.human.sex == 'female'
                        context.fillStyle = 'rgba(255,100,255,' + alpha + ')'
                    else
                        context.fillStyle = 'rgba(100,150,200,' + alpha + ')'


                context.fillRect(
                    renderPosition.x - (size / 2),
                    renderPosition.y - (size / 2),
                    size,
                    size
                )
                
                #if there is an image, draw the image
                context.restore()
            
            return @
    
    return Renderer
)
