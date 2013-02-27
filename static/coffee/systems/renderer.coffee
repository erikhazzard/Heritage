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
            @healthScale = d3.scale.linear()
                .domain([0, 100])
                .range([0, 20])
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
                context.save()
                
                #Get the position to render to
                renderPosition = entity.components.position
                size = entity.components.renderer.size

                #------------------------
                #
                # CAMERA - get positions
                #
                #------------------------
                #TODO: if there is an image, draw the image
                
                #If we can see wrapped around area, draw it
                targetX = renderPosition.x - (size / 2) - @camera.x + @canvasHalfWidth
                targetY = renderPosition.y - (size / 2) - @camera.y + @canvasHalfHeight
                
                #Draw entities that are in the "next" location (wraped around world)
                #if targetX < 0
                    #targetX = canvas.width + targetX
                #if targetY < 0
                    #targetY = canvas.height + targetY
                    
                #if renderPosition.y > @camera.y + @canvasHalfHeight
                    #targetY = renderPosition.y - (size / 2) - @canvasHalfHeight
                #if renderPosition.x > @camera.x + @canvasHalfWidth
                    #targetX = renderPosition.x - (size / 2) - @canvasHalfWidth
                    ##targetY = targetY - @camera.y
                    

                #Setup the canvas
                entityFill = entity.components.renderer.color
                
                #------------------------
                #
                # Draw entities
                #
                #------------------------
                #------------------------
                #Color humans based on sex and age
                #------------------------
                if entity.hasComponent('human')
                    alpha = Math.round( (1-(entity.components.human.age / 110)) * 10 ) / 10
                    
                    #AGE
                    if entity.components.human.age < 20
                        entityFill = 'rgba(0,0,0,0.9)'
                    else if entity.components.human.age > 64
                        entityFill = 'rgba(150,150,150,0.9)'
                    
                    #GENDER
                    if entity.components.human.age > 19 and entity.components.human.age < 65
                        if entity.components.human.sex == 'female'
                            entityFill = 'rgba(255,100,255,' + alpha + ')'
                        else
                            entityFill = 'rgba(100,150,200,' + alpha + ')'

                    #Draw outline if pregnant
                    if entity.components.human.isPregnant
                        context.save()
                        context.strokeStyle = 'rgba(0,255,0,0.5)'
                        context.lineWidth = 8
                        context.strokeRect(
                            targetX,
                            targetY,
                            size,
                            size
                        )
                        context.restore()
                    
                    #Draw the user's mate
                    if @entities.entities[0] and @entities.entities[0].components.human and entity.id == @entities.entities[0].components.human.mateId

                        context.save()
                        context.strokeStyle = 'rgba(0,255,255,0.5)'
                        context.lineWidth = 8
                        context.strokeRect(
                            targetX,
                            targetY,
                            size,
                            size
                        )
                        context.restore()

                    #If entity has a mate, draw outline
                    if entity.components.human and entity.components.human.mateId
                        context.save()
                        context.strokeStyle = 'rgba(255,100,255,0.5)'
                        context.strokeRect(
                            targetX,
                            targetY,
                            size,
                            size
                        )
                        context.restore()

                #ZOMBIE
                #------------------------
                if entity.hasComponent('zombie')
                    entityFill = 'rgba(255,100,100,1)'
                    
                #Draw HEALTH bar
                #------------------------
                if entity.components.health
                    healthSize = @healthScale(entity.components.health.health)
                    context.save()
                    context.beginPath()
                    context.moveTo(targetX - size, targetY - size - 10)
                    context.lineTo(targetX + healthSize, targetY - size - 10)
                    context.fillStyle = 'rgba(0,0,0,1)'
                    context.fill()
                    context.stroke()
                    context.closePath()
                    context.restore()

                #Draw PC entity
                #------------------------
                context.save()
                context.fillStyle= entityFill
                context.fillRect(
                    targetX,
                    targetY,
                    size,
                    size
                )
                context.restore()
                
                #Draw outline around entity
                if entity.hasComponent('userMovable')
                    context.save()
                    context.strokeStyle = 'rgba(100,150,200,1)'
                    context.lineWidth = 2
                    context.strokeRect(
                        targetX,
                        targetY,
                        size,
                        size
                    )
                    context.restore()

                #COMBAT
                #------------------------
                if entity.hasComponent('combat')
                    if entity.components.combat.canAttack
                        context.save()
                        context.beginPath()
                        context.strokeStyle = 'rgba(255,0,0,0.2)'
                        context.lineWidth = 2
                        #context.strokeRect(
                            #targetX,
                            #targetY,
                            #size,
                            #size
                        #)
                        context.arc(
                            targetX + (size / 2),
                            targetY + (size / 2),
                            10,
                            0,
                            20
                        )
                        context.stroke()
                        context.restore()
                
                #------------------------
                #
                #DRAW MINIMAP
                #
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
                        (renderPosition.x / 8) - @canvasHalfWidth / 4,
                        (renderPosition.y / 8) - @canvasHalfHeight / 4,
                        @canvasHalfWidth / 2,
                        @canvasHalfHeight / 2
                    )
                    
                miniMapContext.fillRect(
                    renderPosition.x / 8 - 1,
                    renderPosition.y / 8 - 1,
                    2,
                    2
                )
                
                miniMapContext.restore()
                
            return @
    
    return Renderer
)
