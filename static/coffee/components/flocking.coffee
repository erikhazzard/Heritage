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
define(['components/vector', 'components/physics', 'lib/d3'], (Vector, Physics, d3)->
    class Flocking
        constructor: (entity, params)->
            params = params || {}
            
            #Boids flocking behavior modifiers
            @rules = {}
            @rules.separate = params.separate || Math.random() * 2
            @rules.align = params.align || Math.random() * 2
            @rules.cohesion = params.cohesion || Math.random() * 2

            #Distance to check for cohesion and alignment rules within
            @flockDistance = params.flockDistance || 40
            @separationDistance = params.separationDistance || null
            
            @entity = entity
            return @
        
    return Flocking
)
