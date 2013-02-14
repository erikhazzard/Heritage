#============================================================================
#
#Physics component
#   Defines physics component - velocity, acceleration, etc.
#
#   Dependencies / Coupling:
#       -entity: position
#       -entitiy: world
#
#   NOTES: Physics is tightly coupled to entity. 
#   tick() function - should this live here, or in the physics
#       system?
#============================================================================
define(['components/vector', 'lib/d3'], (Vector, d3)->
    class Physics
        constructor: (entity, params)->
            params = params || {}
            @entity = entity
            
            #State variables 
            @velocity = new Vector(0,0)
            @acceleration = new Vector(0,0)
    
            #limiting variables
            @maxSpeed = params.maxSpeed || 8
            @maxForce = params.maxForce || 5
            
            #furthest away an entity can seek
            @maxSeekForceDistance = params.maxSeekForceDistance || 150
            
            #mass (not used yet?)
            @mass = params.mass || 10
            
            #Max width / height
            #  Set some defaults (in case there is no entity with a world 
            #  component passed in)
            @maxX = 500
            @maxY = 500
            
            if @entity and @entity.components.world
                @maxX = @entity.components.world.width
                @maxY = @entity.components.world.height
                
            return @
        
        #Tick function
        #--------------------------------
        tick: (delta)->
            #Update velocity
            @velocity.add(@acceleration)
            @velocity.limit(@maxSpeed)

            #Wrap around the world if need be
            #TODO: Should this live here, or some where else?
            @checkEdges()
            
            #update the entity's position
            if @entity
                @entity.components.position.add(@velocity)
            
            #reset acceleration to 0
            @acceleration.multiply(0)
            
            return @
            
        #--------------------------------
        #
        #Helper functions
        #
        #--------------------------------
        #--------------------------------
        #MOVEMENT
        #--------------------------------
        checkEdges: ()->
            #TODO: Should this be placed in the world component? Seems like it
            #Wrap around 
            #X
            if @entity.components.position.x >= @maxX
                @entity.components.position.x = @entity.components.position.x % (@maxX)
            else if @entity.components.position.x < 0
                @entity.components.position.x = @maxX - 1
                
            #Y
            if @entity.components.position.y >= @maxY
                @entity.components.position.y = @entity.components.position.y % (@maxY)
            else if @entity.components.position.y < 0
                @entity.components.position.y = @maxY - 1
                
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
        seekForce: (target, maxDistance, flee)->
            #Calculate steering force towards a target and returns the force
            #  If maxDistance is passed in, specifies how far to check for neighbors
            #  If flee is passed in, force is multiplied by -1
            
            #How far to check for neighbors in
            maxDistance = maxDistance || 80
            
            #check if the passed in object has a position property
            if target and target.components and target.components.position
                target = target.components.position
                
            #store reference
            #TODO: Should we reference @entity here? If we do, it requires
            #  us to pass in a physics component (might not be bad, since we
            #  limit force and look at other properties of the physics 
            #  component
            position = @entity.components.position

            #seek a target
            desiredVelocity = Vector.prototype.subtract(
                target,
                position)

            #-----------------------------------
            #get distance threshold
            #-----------------------------------
            if @maxSeekForceDistance
                curDistance = position.distance(target)
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
            steerLine = Vector.prototype.add(position, steer)
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

    return Physics
)
