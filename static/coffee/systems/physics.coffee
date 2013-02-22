#============================================================================
#
#Systems - Physics
#   Handles entity physics
#
#============================================================================
define(['components/vector'], (Vector)->
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
        #HUAMN - Helpers
        #
        #--------------------------------
        humanZombieBehavior: (entity)->
            #There are two possibilities here - a human will either flee 
            #   or chase a zombie if it finds one
            #
            #   Generally, if there are more humans than zombies in the 
            #   entity's neighborhood, the human will want to chase the 
            #   zombie
            #       -Chase / flee behavior is also modified by the entity's
            #       health
            physics = entity.components.physics
            behvaiorForce = new Vector(0,0)
            
            if entity.hasComponent('human') and @entities.entitiesIndex.zombie
                #If this is a human and there are zombies in the world
                numHumans = numZombies = 0
                
                #Go through all neighbor cells and flee from any zombies 
                #quicker to loop through neighboring cells than ALL entities
                #  4 is the radius we want to look for neighbors with
                #
                #First we need to count number of zombies and human neighbors
                neighbors = []
                for neighbor in entity.components.world.getNeighbors(5)
                    if neighbor.hasComponent('zombie')
                        numZombies += 1
                    if neighbor.hasComponent('human')
                        numHumans += 1
                    #keep track of neighbors so we don't need to call function
                    #  again
                    if neighbor != entity
                        neighbors.push(neighbor)
                    
                #Let's calculate some number based off the entity's health and
                # other attribtues to add to the pursuit calculation
                pursuitDesire = 0
                
                #if low health or young / old age, very strongly wants to flee
                #TODO: put health as its own component
                if entity.components.health.health < 20
                    pursuitDesire -= 2
                if entity.components.human.age < 10 or entity.components.human.age > 80
                    pursuitDesire -= 3
                   
                #Now check to see if the entity should flee or pursue a zombie
                for neighbor in neighbors
                    #if it's a zombie
                    if neighbor.hasComponent('zombie')
                        zombie = neighbor
                        scale = (numHumans / 2.5) - numZombies
                        scale += pursuitDesire
                        
                        #don't go too crazy pursuing zombies
                        if scale > 1
                            scale = 1
                        #or too crazy gettings away
                        else if scale < -5
                            scale = -5

                        #Apply the force. If it's positive, the human chases
                        #  zombie. If negative, human flees
                        behaviorForce = physics.seekForce(
                            zombie
                        ).multiply(scale)
                        #add it
                        physics.applyForce(
                            behaviorForce
                        )
                        
                return behaviorForce
        
        #--------------------------------
        #
        #Main tick funciton
        #
        #--------------------------------
        tick: (delta)->
            for id, entity of @entities.entitiesIndex['physics']
                #Store ref
                physics = entity.components.physics
                
                #Don't do any AI movement if entity is userMovable
                #  NOTE: TODO: Should this be allowed? Maybe a property of
                #  the component
                if entity.hasComponent('userMovable') == false
                    #If entity has a randomWalker component, make it walk
                    if entity.hasComponent('randomWalker')
                        physics.applyForce( entity.components.randomWalker.walkForce() )
                        
                    #BOIDS / Flocking  - TODO: own system?
                    #------------------------
                    if entity.hasComponent('flocking')
                        #Only flock with same type of creature
                        if entity.hasComponent('human')
                            entity.components.flocking.flock(
                                @entities.entitiesIndex.human
                            )
                            
                        #Zombies try to flock together
                        if entity.hasComponent('zombie')
                            entity.components.flocking.flock(
                                @entities.entitiesIndex.zombie,
                                #make the multiplier for flocking a bit smaller
                                0.7
                            )
                            
                    #------------------------
                    #Human movement - TODO: own system?
                    #------------------------
                    if entity.hasComponent('human') and not entity.hasComponent('userMovable')
                        # Flee or Pusue zombies
                        @humanZombieBehavior(entity)

                        #Human - Seek out mate and children
                        #------------------------
                        #if entity has a mate, seek it out
                        human = entity.components.human
                        #MATE
                        mateId = human.mateId
                        if mateId != null
                            #make sure entity is still alive
                            if @entities.entities[mateId]
                                physics.applyForce(
                                    physics.seekForce(
                                        @entities.entities[mateId],
                                        #override how far to seek out a mate
                                        700, true
                                    ).multiply(2.5)
                                )
                                
                        #CHILDREN
                        if human.children.length > 0
                            for childId in human.children
                                child = @entities.entities[childId]
                                #Stay near the child if the child isn't too old
                                if child and child.components.human.age < 10
                                    physics.applyForce(
                                        physics.seekForce(
                                            child
                                        ).multiply(1.4)
                                    )
                    #------------------------
                    #ZOMBIE movement - TODO: own system?
                    #------------------------
                    if entity.hasComponent('zombie') and not entity.hasComponent('userMovable')
                        #Zombies just want brains
                        #  go after first human in it's neighborhood
                        zombie = entity.components.zombie
                        for neighbor in entity.components.world.getNeighbors(zombie.seekRange)
                            if neighbor.hasComponent('human')
                                #Chase human
                                chaseForce = physics.seekForce(
                                    neighbor
                                ).multiply(6)
                                entity.components.physics.applyForce(
                                    chaseForce
                                )
                                
                                #we found a human, so we're done with loop
                                break
                            
        
                #UPDATE (tick)
                #------------------------
                #Lastly, call the physics component's tick function, which will
                #  update the entity's position component
                @updatePhysics(entity)

            return @
            
    return Physics
)
