#============================================================================
#
#Systems - Physics
#   Handles entity physics
#
#============================================================================
define([], ()->
    #Nasty, hardcoded canvas for now    
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    
    class Physics
        constructor: (entities)->
            @entities = entities
            return @
        
        tick: (delta)->
            for id, entity of @entities.entitiesIndex['physics']
                #Store ref
                physics = entity.components.physics
                
                #WALKING BEHAVIOR
                #------------------------
                #If entity has a randomWalker component, make it walk
                if entity.hasComponent('randomWalker')
                    physics.applyForce( entity.components.randomWalker.walkForce() )
                    
                #BOIDS / Flocking
                #------------------------
                    
                #UPDATE (tick)
                #------------------------
                #Lastly, call the physics component's tick function, which will
                #  update the entity's position component
                entity.components.physics.tick(delta)
            
    return Physics
)
