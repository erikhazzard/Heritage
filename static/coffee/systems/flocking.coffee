#============================================================================
#
#Systems - flocking
#   Handles entity flocking (sub system of physics)
#
#============================================================================
define(['components/vector', 'components/physics'], (Vector, Physics)->
    class Flocking
        constructor: (entities)->
            @entities = entities
            return @
        
        #--------------------------------
        #
        #Helpers
        #
        #--------------------------------
        separate: (entity, entities)->
            #Apply a separation force between this entity and a list of
            #  passed in entities.  If the distance is greater than some
            #  value, don't apply the force
            targetEntity = null
            curDistance = 0
            diffVector = null
            sumVector = new Vector(0,0)
            count = 0
            steer = new Vector(0,0)
            
            #References to entity components used in this function
            position = entity.components.position
            flocking = entity.components.flocking
            maxSpeed = entity.components.physics.maxSpeed
            velocity = entity.components.physics.velocity

            separationDistance = flocking.separationDistance || entity.components.physics.mass

            #Temporary hack for passing in array of IDs
            if entities.length
                tmpEntities = {}
                for id in entities
                    tmpEntities[id] = @entities.entities[id]
                entities = tmpEntities

            for key, targetEntity of entities
                #Make sure we don't check this entity
                if entity.id == targetEntity.id
                    continue
                    
                curDistance = position.distance(
                    targetEntity.components.position
                )

                #Make sure entity is within range of other entities
                if curDistance > 0 and curDistance < separationDistance and (targetEntity != @)
                    #get vector which points away (get a new vector)
                    diffVector = Vector.prototype.subtract(
                        position,
                        targetEntity.components.position
                    )
                    diffVector.normalize()
                    diffVector.divide(curDistance)
                    #closer it is, further it should flee
                    sumVector.add(diffVector)
                    count += 1

            #divide to get average
            if count > 0
                sumVector.divide(count)
                sumVector.normalize()
                sumVector.multiply(maxSpeed)

                steer = Vector.prototype.subtract(sumVector, velocity)
                steer.limit(maxSpeed)
                #lower the force even more
                #steer.divide(4)
                
            return steer

        align: (entity, entities)->
            #Alignment means entities try to head in the same direction
            sum = new Vector(0,0)
            i=0
            curDistance = 0
            count = 0
            
            #references
            position = entity.components.position
            flocking = entity.components.flocking
            physics = entity.components.physics

            velocity = physics.velocity
            maxSpeed = physics.maxSpeed
            maxForce = physics.maxForce

            distance = flocking.flockDistance

            #Get sum vector of velocity of all surrounding entities
            for key, targetEntity of entities
                #Make sure we don't check this entity
                if entity.id == targetEntity.id
                    continue
                
                curDistance = position.distance(targetEntity.components.position)
                if curDistance <= distance
                    if targetEntity.components.physics
                        sum.add(targetEntity.components.physics.velocity)
                        count += 1
                    
            steer = new Vector(0,0)
            
            #Divide the sum velocity to get the average and apply a steer force
            #   towards it
            if count > 0
                sum.divide(count)
                sum.normalize()
                sum.multiply(maxSpeed)
                steer = Vector.prototype.subtract(sum, velocity)
                steer.limit(maxForce)
            
            return steer
    
        cohesion: (entity, entities)->
            #Cohesion affects how the entities stick together
            sum = new Vector(0,0)
            i=0
            curDistance = 0
            count = 0
            
            #References
            position = entity.components.position
            physics = entity.components.physics
            seekForce = Physics.prototype.seekForce

            flocking = entity.components.flocking
            distance = flocking.flockDistance

            #add sum of vectors of neighbors
            for key, targetEntity of entities
                #Make sure we don't check this entity
                if entity.id == targetEntity.id
                    continue
                
                curDistance = position.distance(targetEntity.components.position)
                if curDistance <= distance
                    sum.add(targetEntity.components.position)
                    count += 1
                    
            #Setup seek force
            steer = new Vector(0,0)
            
            #Divide the sum and set the seek force
            if count > 0
                sum.divide(count)
                #when calling seekForce, pass in this context
                steer = seekForce.call(physics, sum)
            
            return steer

        #--------------------------------
        #Boids - Flock behavior
        #--------------------------------
        flock: (entity, entities, multiplier)->
            #Performs flocking behavior with a group of passed in
            #entities. Should pass in an entitiesIndex object
            multiplier = multiplier || 1
            flockComponent = entity.components.flocking
            
            if not entities
                console.log('ERROR: COMPONENT: FLOCKING')
                console.log('must pass in entities object')
            #Get each rule
            sep = @separate(entity, entities)
            align = @align(entity, entities)
            cohesion = @cohesion(entity, entities)

            #Mutliply the values by the comopnent values AND multiplier if passed 
            sep.multiply(flockComponent.rules.separate).multiply(multiplier)
            align.multiply(flockComponent.rules.align).multiply(multiplier)
            cohesion.multiply(flockComponent.rules.cohesion).multiply(multiplier)
            
            #Apply the force
            physics = entity.components.physics
            physics.applyForce(sep)
            physics.applyForce(align)
            physics.applyForce(cohesion)
            
            return @
        
        #--------------------------------
        #
        #Main tick funciton
        #
        #--------------------------------
        tick: (delta)->
            for id, entity of @entities.entitiesIndex['flocking']
                #Only flock with same type of creature
                if entity.hasComponent('human')
                    @flock(
                        entity,
                        @entities.entitiesIndex.human
                    )
                    
                #Zombies try to flock together
                if entity.hasComponent('zombie')
                    @flock(
                        entity,
                        @entities.entitiesIndex.human,
                        0.5
                    )

            return @
            
    return Flocking
)
