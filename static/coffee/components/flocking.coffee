#============================================================================
#
#Flocking component
#   Defines behaviors / data for flocking
#
#   Dependencies / Coupling:
#       -entity: position
#       -entity: physics
#       -physics component prototype: seekForce
#
#   NOTES: Used by the physics system
#============================================================================
define(['components/vector', 'components/physics'], (Vector, Physics)->
    class Flocking
        constructor: (entity, params)->
            params = params || {}
            
            #Boids flocking behavior modifiers
            @rules = {}
            @rules.separate = params.separate || 0.8
            @rules.align = params.align || 0.7
            @rules.cohesion = params.cohesion || 0.7
            
            #Distance to check for cohesion and alignment rules within
            @flockDistance = params.flockDistance || 40
            @separationDistance = params.separationDistance || null
            
            @entity = entity
            return @
        
        #---------------------------------------
        #
        #Behaviors - Desired forces
        #
        #---------------------------------------
        separate: (entities)->
            #Apply a separation force between this entity and a list of
            #  passed in entities.  If the distance is greater than some
            #  value, don't apply the force
            separationDistance = @separationDistance || @entity.components.physics.mass
            targetEntity = null
            curDistance = 0
            diffVector = null
            sumVector = new Vector(0,0)
            count = 0
            steer = new Vector(0,0)
            
            #References to entity components used in this function
            position = @entity.components.position
            maxSpeed = @entity.components.physics.maxSpeed
            velocity = @entity.components.physics.velocity

            for key, targetEntity of entities
                #Make sure we don't check this entity
                if @entity == targetEntity
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

        align: (entities)->
            #Alignment means entities try to head in the same direction
            distance = @flockDistance
            sum = new Vector(0,0)
            i=0
            entity=null
            curDistance = 0
            count = 0
            
            #references
            position = @entity.components.position
            velocity = @entity.components.physics.velocity
            maxSpeed = @entity.components.physics.maxSpeed
            maxForce = @entity.components.physics.maxForce

            #Get sum vector of velocity of all surrounding entities
            for key, targetEntity of entities
                #Make sure we don't check this entity
                if @entity == targetEntity
                    continue
                
                curDistance = position.distance(targetEntity.components.position)
                if curDistance <= distance
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
    
        cohesion: (entities)->
            #Cohesion affects how the entities stick together
            sum = new Vector(0,0)
            i=0
            entity=null
            distance = @flockDistance
            curDistance = 0
            count = 0
            
            #References
            position = @entity.components.position
            physics = @entity.components.physics
            seekForce = physics.seekForce

            #add sum of vectors of neighbors
            for key, targetEntity of entities
                #Make sure we don't check this entity
                if @entity == targetEntity
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
                #when calling seekForce, pass in the physics context
                steer = seekForce.call(physics, sum)
            
            return steer

        #--------------------------------
        #
        #Boids - Flock behavior
        #
        #--------------------------------
        flock: (entities)->
            #Performs flocking behavior with a group of passed in
            #entities. Should pass in an entitiesIndex object
            if not entities
                console.log('ERROR: COMPONENT: FLOCKING')
                console.log('must pass in entities object')
                

            #Get each rule
            sep = @separate(entities)
            align = @align(entities)
            cohesion = @cohesion(entities)

            #Mutliply the values
            sep.multiply(@rules.separate)
            align.multiply(@rules.align)
            cohesion.multiply(@rules.cohesion)
            
            #Apply the force
            physics = @entity.components.physics
            physics.applyForce(sep)
            physics.applyForce(align)
            physics.applyForce(cohesion)
            
            return @
        
    return Flocking
)
