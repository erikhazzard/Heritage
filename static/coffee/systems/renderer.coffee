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
    
    #MiniMap?
    miniMapCanvas = document.getElementById('miniMap')
    miniMapContext = miniMapCanvas.getContext('2d')
    
    class Renderer
        constructor: (entities)->
            @entities = entities
            @canvasHalfWidth = canvas.width / 2
            @canvasHalfHeight = canvas.height / 2
            return @
            
        tick: (delta)=>
            #Redraw the canvas
            canvas.width = canvas.width
            miniMapCanvas.width = miniMapCanvas.width
            @camera = {
                x:0
                y:0
                radius: 20
            }
            
            #Setup camera
            #TODO: Should only center camera on one entity...
            for id, entity of @entities.entitiesIndex['userMovable']
                @camera.x = entity.components.position.x
                @camera.y = entity.components.position.y
            
            #Renders to the canvas. Ideally, we'd use events here
            for id, entity of @entities.entitiesIndex['renderer']
                size = entity.components.renderer.size
                context.save()
                
                #Get the position to render to
                renderPosition = entity.components.position

                #Setup the canvas
                context.fillStyle = entity.components.renderer.color
                
                #Color humans based on sex and age
                if entity.components.human
                    alpha = Math.round( (1-(entity.components.human.age / 110)) * 10 ) / 10
                    
                    #Color based on age and gender
                    if entity.components.human.age < 20
                        context.fillStyle = 'rgba(0,0,0,0.9)'
                    else if entity.components.human.age > 64
                        context.fillStyle = 'rgba(190,190,190,0.9)'
                    
                    if entity.components.human.age > 19 and entity.components.human.age < 65
                        if entity.components.human.sex == 'female'
                            context.fillStyle = 'rgba(255,100,255,' + alpha + ')'
                        else
                            context.fillStyle = 'rgba(100,150,200,' + alpha + ')'

                    
                if entity.hasComponent('zombie')
                    context.fillStyle = 'rgba(255,100,100,1)'
                    
                #Draw square for entity
                #TODO: if there is an image, draw the image
                
                #If we can see wrapped around area, draw it
                targetX = renderPosition.x - (size / 2) - @camera.x + @canvasHalfWidth
                targetY = renderPosition.y - (size / 2) - @camera.y + @canvasHalfHeight
                
                #Draw entities that are in the "next" location (wraped around world)
                if targetX < 0
                    targetX = canvas.width + targetX
                if targetY < 0
                    targetY = canvas.height + targetY
                    
                if renderPosition.y > @camera.y + @canvasHalfHeight
                    targetY = renderPosition.y - (size / 2) - @canvasHalfHeight
                if renderPosition.x > @camera.x + @canvasHalfWidth
                    targetX = renderPosition.x - (size / 2) - @canvasHalfWidth
                    #targetY = targetY - @camera.y
                    
                context.fillRect(
                    targetX,
                    targetY,
                    size,
                    size
                )
                
                if entity.hasComponent('userMovable')
                    context.strokeStyle = 'rgba(100,150,200,1)'
                    context.lineWidth = 2
                    context.strokeRect(
                        targetX,
                        targetY,
                        size,
                        size
                    )
                context.restore()
                
                #------------------------
                #DRAW MINIMAP
                #------------------------
                miniMapContext.save()
                miniMapContext.fillStyle = 'rgba(20,20,20,1)'
                if entity.hasComponent('zombie')
                    miniMapContext.fillStyle= 'rgba(255,20,20,1)'
                if entity.hasComponent('userMovable')
                    miniMapContext.fillStyle= 'rgba(20,255,20,1)'
                    #Draw outline around what entity can see
                    #NOTE: THIS IS NOT PERFECT YET
                    miniMapContext.strokeRect(
                        (renderPosition.x / 6) - @canvasHalfWidth / 4,
                        (renderPosition.y / 6) - @canvasHalfHeight / 4,
                        @canvasHalfWidth / 2,
                        @canvasHalfHeight / 2
                    )
                    
                miniMapContext.fillRect(
                    renderPosition.x / 6 - 1,
                    renderPosition.y / 6 - 1,
                    2,
                    2
                )
                
                miniMapContext.restore()
                
            return @
    
    return Renderer
)
