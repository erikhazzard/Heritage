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
            @maxSpeed = 4
            
            #How far zombie will look for enemies with
            @seekRange = 1 + (Math.random() * 17 | 0)

            #Resources is an abstraction to represent food
            @resources = params.resources || 100
            
            #If the zombie is killed / dead
            @isDead = false
            @decayRate = params.decayRate || Math.abs(d3.random.normal(1,0.4)())
            
            #----------------------------
            #Stats
            #----------------------------
            #more resources = higher strength?
            @strength = Math.random() * 20 | 0
            #Dodge chance? Max Speed?
            @agility = Math.random() * 20 | 0
            
        calculateHealth: (health)->
            #Calculate current health based on age / resources
            
            #Subtract health if resources are scarce
            #happens faster if negative resources
            if @resources < 0
                health -= (0.4 + Math.abs(@resources * 0.04) )
            #slow, natural decay
            else if @resources < 20
                health -= (0.2 + Math.abs(@resources * 0.01) )
            #if resources are high, more life
            else if @resources > 50
                health += (0.005 + Math.abs(@resources * 0.005) )

            return health
        
        getIsDead: (health)->
            #If zombie has too low resources OR health < 0, it's dead
            if health <= 0
                @isDead = true
                
            return @isDead
        
        getMaxSpeed: ()->
            #Returns max speed based on various factors
            maxSpeed = @maxSpeed
            if @resources < 20
                maxSpeed = 2
                
            @maxSpeed = maxSpeed
            return maxSpeed
        
        calculateResources: ()->
            #Base resource consumption on age and other factors
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            resources = @resources
            
            #Resources decay naturally
            resources -= (@decayRate)
            return resources
            
    return Zombie
)
