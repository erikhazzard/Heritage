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
        
        #--------------------------------
        #
        #Helpers
        #
        #--------------------------------
        updatePhysics: (entity)->
            #Update velocity and acceleration of the physics
            #  component
            physics = entity.components.physics
            
            physics.velocity.add(physics.acceleration)
            physics.velocity.limit(physics.maxSpeed)

            #update the entity's position
            if entity
                entity.components.position.add(physics.velocity)
            
            #reset acceleration to 0
            physics.acceleration.multiply(0)
            
            #Wrap around the world if need be
            @checkEdges(entity)
            
            return @
        
        checkEdges: (entity)->
            #Wrap aroundthe world
            physics = entity.components.physics
            position = entity.components.position
            
            #X
            if position.x >= physics.maxX
                position.x = position.x % (physics.maxX)
            else if position.x < 0
                position.x = physics.maxX - 1
                
            #Y
            if position.y >= physics.maxY
                position.y = position.y % (physics.maxY)
            else if position.y < 0
                position.y = physics.maxY - 1
                
            return entity

        
        #--------------------------------
        #
        #Main tick funciton
        #
        #--------------------------------
        tick: (delta)->
            for id, entity of @entities.entitiesIndex['physics']
                #Store ref
                physics = entity.components.physics
                
                #WALKING BEHAVIOR
                #------------------------
                #If entity has a randomWalker component, make it walk
                if entity.hasComponent('randomWalker')
                    physics.applyForce( entity.components.randomWalker.walkForce() )
                    
                #BOIDS / Flocking - TODO: PUT THIS IN OWN SYSTEM
                #------------------------
                if entity.hasComponent('flocking')
                    #Only flock with same type of creature
                    if entity.hasComponent('human')
                        entity.components.flocking.flock(@entities.entitiesIndex.human)
                        
                    #Zombies try to flock together
                    if entity.hasComponent('zombie')
                        entity.components.flocking.flock(@entities.entitiesIndex.zombie)
                        
                #------------------------
                #Human - Flee from zombies
                #------------------------
                #If this is a human and there are zombies in the world
                if entity.hasComponent('human') and @entities.entitiesIndex.zombie
                    
                    #Go through all neighbor cells and flee from any zombies 
                    #quicker to loop through neighboring cells than ALL entities
                    #  4 is the radius we want to look for neighbors with
                    for neighbor in entity.components.world.getNeighbors(4)
                        if neighbor.hasComponent('zombie')
                            zombie = neighbor

                            #multiply by -1 to make it flee
                            physics.applyForce(
                                physics.seekForce(
                                    zombie,20
                                ).multiply(-8)
                            )
                    

                #Human - Seek out mate
                #------------------------
                #if entity has a mate, seek it out
                if entity.hasComponent('human')
                    mateId = entity.components.human.mateId
                    if mateId != null
                        #make sure entity is still alive
                        if @entities.entities[mateId]
                            physics.applyForce(
                                physics.seekForce(
                                    @entities.entities[mateId]
                                ).multiply(2)
                            )
        
                #UPDATE (tick)
                #------------------------
                #Lastly, call the physics component's tick function, which will
                #  update the entity's position component
                @updatePhysics(entity)
            
    return Physics
)
