#============================================================================
#
#WalkForce component
#   Defines walk force component
#
#   Dependencies / Coupling:
#       -entity: position
#       -entity: physics
#       -physics component prototype: seekForce
#
#   NOTES: Walking force is used by the Physics SYSTEM to make entity walk
#     around if the entity has this component
#============================================================================
define(['components/vector', 'components/physics', 'lib/d3'], (Vector, Physics, d3)->
    class RandomWalker
        constructor: (entity, params)->
            params = params || {}
            @entity = entity
            return @
            
        #Helper / optimization lookups
        cosLookup: {}
        sinLookup: {}
            
        walkForce: (futureDistance, radius)->
            #Pick a spot based on current velocity, then randomly
            #  pick a spot at radius r at a random angle. This is
            #  the new target
            futureDistance = futureDistance or 40
            radius = radius or 30

            futurePosition = @entity.components.position.copy()
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
            
            #Lookup table - minor optimization
            #COS
            cosLookup = RandomWalker.prototype.cosLookup
            if not cosLookup[randomAngle]
                cosLookup[randomAngle] = Math.cos(randomAngle)
            cos = cosLookup[randomAngle]
                
            #SIN
            sinLookup = RandomWalker.prototype.sinLookup
            if not sinLookup[randomAngle]
                sinLookup[randomAngle] = Math.sin(randomAngle)
            sin = sinLookup[randomAngle]
            
            #Get x / y using radis and cos / sin
            x = radius * cos
            y = radius * sin

            #now we got the target
            target = new Vector(x,y)

            #Add the target location to the entity's position
            target.add(@entity.components.position)

            #we have target now, so seek it
            #  seekForce uses this.entity, so pass in this context (which has
            #  a reference to entity)
            force = Physics.prototype.seekForce.call(
                #Pass in reference to physics component
                @entity.components.physics,
                target
            )
            
            return force
        
    return RandomWalker
)
