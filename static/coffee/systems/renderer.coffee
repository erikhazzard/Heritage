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
                context.fillRect(
                    renderPosition.x - (size / 2),
                    renderPosition.y - (size / 2),
                    size,
                    size
                )
                
                #If entity is selected, draw an outline
                if entity.components.renderer.isSelected
                    context.strokeRect(
                        renderPosition.x - (size / 2),
                        renderPosition.y - (size / 2),
                        size,
                        size
                    )
                context.restore()
                
                #Clear out selection
                entity.components.renderer.isSelected = false
            
            return @
    
    return Renderer
)
