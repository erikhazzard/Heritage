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
            @maxSpeed = 5
            @maxBaseSpeed = @maxSpeed
            
            #How far zombie will look for enemies with
            @seekRange = 10

            #Resources is an abstraction to represent food
            @resources = params.resources || 100
            
            #Keep track of zombies in its 'group'
            #   used to transfer control upon death if the PC
            #   is a zombie
            @group = []
            
            #If the zombie is killed / dead
            @isDead = false
            @decayRate = params.decayRate || Math.abs(d3.random.normal(0.4,0.05)())
            
            @humansInfected = []
        
        getIsDead: (health)->
            #If zombie has too low resources OR health < 0, it's dead
            if health <= 0
                @isDead = true
                
            return @isDead
            
    return Zombie
)
