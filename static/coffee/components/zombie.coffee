#============================================================================
#
#Zombie component
#   Defines zombie component - defines life, resources, age, etc
#
#   TODO: Should human / zombie / etc assume creature component exists, or
#   manually create it?
#
#   Dependencies / Coupling:
#
#============================================================================
define(['lib/d3'], (d3)->
    class Zombie
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            #Age doesn't affect anything - zombies are undead
            @age = params.age || 0.1
            @maxSpeed = 6
            
            #How far zombie will look for enemies with
            @seekRange = 8

            #Resources is an abstraction to represent food
            @resources = params.resources || 100
            
            #If the zombie is killed / dead
            @isDead = false
            @decayRate = params.decayRate || Math.abs(d3.random.normal(0.2,0.05)())
        
        getIsDead: (health)->
            #If zombie has too low resources OR health < 0, it's dead
            if health <= 0
                @isDead = true
                
            return @isDead
            
    return Zombie
)
