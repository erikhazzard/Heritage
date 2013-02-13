#============================================================================
#
#Physics component
#   Defines physics component - velocity, acceleration, etc.
#
#   Dependencies / Coupling:
#       -entity: position
#
#   NOTES: Physics is tightly coupled to entity. 
#   tick() function - should this live here, or in the physics
#       system?
#============================================================================
define(['components/vector'], (Vector)->
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
            @maxSeekForceDistance = params.maxSeekForceDistance || 100
            
            #mass (not used yet?)
            @mass = params.mass || 10
            
            return @
        
        #Tick function
        #--------------------------------
        tick: (delta)->
            #Update velocity
            @velocity.add(@acceleration)
            @velocity.limit(@maxSpeed)

            #Wrap around the world if need be
            #TODO: Should this live here, or some where else?
            #@checkEdges()
            
            #update the entity's position
            if @entity
                @entity.components.position.add(@velocity)
            
            #reset acceleration to 0
            @acceleration.multiply(0)
            
        #--------------------------------
        #Helper functions
        #--------------------------------
        
    return Physics
)
