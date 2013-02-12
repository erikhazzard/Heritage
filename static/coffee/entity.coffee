#============================================================================
#
#Entity Class - Definition for Entity
#
#============================================================================
define(['components/vector', 'world'], (Vector, world)->
    class Entity
        #Constants
        @DEFAULTS = {
            health: 80
            food: 40
        }

        constructor: (params) ->
            #Setup the entity
            params = params or {}
            rules = params.rules || {}

            #MOVEMENT
            #----------------------------
            @position = params.position or new Vector(
                Math.random() * 200 | 0,
                Math.random() * 200 | 0
            )
            @positionMax = params.positionMax or new Vector(
                world.width,
                world.height
            )
            @positionGrid = {i: 0, j: 0}
            @cellSize = params.cellSize || world.cellSize

            @velocity = params.velocity or new Vector(0,0)
            @acceleration = params.acceleration or new Vector(0,0)
            @maxSpeed = params.maxSpeed or 8
            @maxForce = params.maxForce or .5
            @maxSeekForceDistance = params.maxSeekForceDistance or 100
            
            #Flocking behavior
            #----------------------------
            @rules = {
                #Boids behavior for seeking members of the same group
                align: rules.align or Math.random() * 2
                cohesion: rules.cohesion or Math.random() * 2
                separate: rules.separate or Math.random() * 2
            }
            
            #Stats
            #----------------------------
            @health = params.health or Entity.DEFAULTS.health
            #when food goes below 0, it starts taking away health
            @food = params.food or Entity.DEFAULTS.food
            @mass = params.mass or (Math.random() * 20 | 0) + 5

            @color = params.color
            if not @color
                @color = 'rgba(' + (Math.random() * 255 | 0) \
                + ',' + (Math.random() * 255 | 0) + ',' \
                + (Math.random() * 255 | 0) \
                + ',' \
                + '1)'

            return @
    
        update: ()->
            #Adds the velocity to the location
            @velocity.add(@acceleration)
            @velocity.limit(@maxSpeed)

            @position.add(@velocity)
            @checkEdges()
            @updatePositionGrid()

            #reset acceleration
            @acceleration.multiply(0)
            
        updatePositionGrid: ()->
            #NOTE: should this live in a grid class?
            @positionGrid = {
                i: Math.floor(@position.y / @cellSize)
                j: Math.floor(@position.x / @cellSize)
            }
            return @

        draw: ()->
            #Draw entity to canvas 
            #TODO: BREAK UP LOGIC
            context.save()
            context.fillStyle = @color
            context.fillRect(
                @position.x - (@mass / 2),
                @position.y - (@mass / 2),
                @mass,
                @mass
            )
            context.restore()
            
        #--------------------------------
        #MOVEMENT
        #--------------------------------
        checkEdges: ()->
            #Wrap around 
            if @position.x >= @positionMax.x
                @position.x = @position.x % (@positionMax.x)
            else if @position.x < 0
                @position.x = @positionMax.x - 1
                
            if @position.y >= @positionMax.y
                @position.y = @position.y % (@positionMax.y)
            else if @position.y < 0
                @position.y = @positionMax.y - 1
                
            return @

        applyForce: (force)->
            #Add the passed in force to the acceleration
            @acceleration.add( force.copy() )
            return force

        #---------------------------------------
        #
        #Seek force
        #
        #---------------------------------------
        #Calculate steering force towards a target
        seekForce: (target, flee)->
            #How far to check for neighbors in
            maxDistance = 100
            
            #check if the passed in object has a position property
            if target and target.position
                target = target.position

            #seek a target
            desiredVelocity = Vector.prototype.subtract(
                target,
                @position)

            #-----------------------------------
            #get distance threshold
            #-----------------------------------
            if @maxSeekForceDistance
                curDistance = @position.distance(target)
                #Make sure entity is within range of other entities
                if curDistance <= 0 or curDistance > @maxSeekForceDistance
                    return new Vector(0,0)

            #-----------------------------------
            #Arriving behavior - slow down on approach if within radius
            #-----------------------------------
            distance = desiredVelocity.magnitude()
            magnitude = 0

            scale = d3.scale.linear()
                .domain([0, maxDistance])
                .range([0, @maxSpeed])

            #val to map, current range min and max, then output range
            if distance < maxDistance
                magnitude = scale(distance)
                desiredVelocity.multiply(magnitude)
            else
                #outside of radius, so go max speed towards it
                desiredVelocity.multiply(@maxSpeed)

            #steer force
            steer = Vector.prototype.subtract(
                desiredVelocity,
                @velocity)

            #draw the line (optional)
            #-----------------------------------
            steerLine = Vector.prototype.add(@position, steer)
            #GAME.util.drawLine(@position, steerLine)
            #GAME.util.drawLine(
                #@position, 
                #Vector.prototype.add(@position, @velocity)
            #)

            #limit steer amount
            #-----------------------------------
            steer.limit(@maxForce)

            if flee
                steer.multiply(-1)
            
            return steer

        #Helper / optimization lookups
        cosLookup: {}
        sinLookup: {}
        
        #--------------------------------
        #
        #Walk movement
        #
        #--------------------------------
        walkForce: (futureDistance, radius)->
            #Pick a spot based on current velocity, then randomly
            #  pick a spot at radius r at a random angle. This is
            #  the new target
            futureDistance = futureDistance or 40
            radius = radius or 30

            futurePosition = @velocity.copy()
            futurePosition.normalize()

            #If entity is NOT already moving, make it move
            if futurePosition.magnitude() < 0.1
                #Random position
                futurePosition.add(
                    new Vector(
                        (Math.random() * 3 | 0) - 1 or 1,
                        (Math.random() * 3 | 0) - 1 or 1
                    )
                )
            
            #set the length of the vector
            futurePosition.multiply(futureDistance)

            #get a random position
            scale = d3.scale.linear()
                .domain([0,1])
                .range([0,360])

            randomAngle = Math.random() * 361 | 0
            
            #Lookup table (nasty - todo make this better)
            #COS
            cosLookup = Entity.prototype.cosLookup
            if not cosLookup[randomAngle]
                cosLookup[randomAngle] = Math.cos(randomAngle)
            cos = cosLookup[randomAngle]
                
            #SIN
            sinLookup = Entity.prototype.sinLookup
            if not sinLookup[randomAngle]
                sinLookup[randomAngle] = Math.sin(randomAngle)
            sin = sinLookup[randomAngle]
            
            #Get x / y using radis and cos / sin
            x = radius * cos
            y = radius * sin

            #now we got the target
            target = new Vector(x,y)

            #Add the target location to the entity's position
            target.add(@position)

            #we have target now, so seek it
            force = @seekForce(target)
            
            return force

        #---------------------------------------
        #
        #Behaviors - Desired forces
        #
        #---------------------------------------
        separate: (entities)->
            #Apply a separation force between this entity and a list of
            #  passed in entities.  If the distance is greater than some
            #  value, don't apply the force
            separationDistance = @mass
            targetEntity = null
            curDistance = 0
            diffVector = null
            sumVector = new Vector(0,0)
            count = 0
            steer = new Vector(0,0)

            for entity in entities
                targetEntity = entities[entity]
                curDistance = @position.distance(targetEntity.position)

                #Make sure entity is within range of other entities
                if curDistance > 0 and curDistance < separationDistance and (targetEntity != @)
                    #get vector which points away (get a new vector)
                    diffVector = Vector.prototype.subtract(@position, targetEntity.position)
                    diffVector.normalize()
                    diffVector.divide(curDistance)
                    #closer it is, further it should flee
                    sumVector.add(diffVector)
                    count += 1

            #divide to get average
            if count > 0
                sumVector.divide(count)
                sumVector.normalize()
                sumVector.multiply(@maxSpeed)

                steer = Vector.prototype.subtract(sumVector, @velocity)
                steer.limit(@maxSpeed)
                #lower the force even more
                #steer.divide(4)
                
            return steer

        align: (entities)->
            distance = 40
            sum = new Vector(0,0)
            i=0
            entity=null
            curDistance = 0
            count = 0

            for i in entities
                entity = entities[i]
                
                curDistance = @position.distance(entity.position)
                if curDistance <= distance
                    sum.add(entity.velocity)
                    count += 1
                    
            steer = new Vector(0,0)
            
            if count > 0
                sum.divide(count)
                sum.normalize()
                sum.multiply(@maxSpeed)
                steer = Vector.prototype.subtract(sum, @velocity)
                steer.limit(@maxForce)
            
            return steer
    
        cohesion: (entities)->
            sum = new Vector(0,0)
            i=0
            entity=null
            distance = 40
            curDistance = 0
            count = 0

            for i in entities
                entity = entities[i]
                
                curDistance = @position.distance(entity.position)
                if curDistance <= distance
                    sum.add(entity.position)
                    count += 1
                    
            steer = new Vector(0,0)
            
            if count > 0
                sum.divide(count)
                steer = @seekForce(sum)
            
            return steer

        
        #--------------------------------
        #Boids - Flock behavior
        #--------------------------------
        flock: (entities)->
            #Get each rule
            sep = @separate(entities)
            align = @align(entities)
            cohesion = @cohesion(entities)

            #Mutliply the values
            sep.multiply(@rules.separate)
            align.multiply(@rules.align)
            cohesion.multiply(@rules.cohesion)
            
            #Apply the force
            @applyForce(sep)
            @applyForce(align)
            @applyForce(cohesion)
            
            return @
        
    return Entity
)
