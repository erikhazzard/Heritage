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
define([], ()->
    class Zombie
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            #When health < 0, entity dies
            @health = params.health || 100
            #Age doesn't affect anything - zombies are undead
            @age = params.age || 0.1

            #Resources is an abstraction to represent food
            @resources = params.resources || 100
            
            #If the zombie is killed / dead
            @isDead = false
            
            #----------------------------
            #Stats
            #----------------------------
            #more resources = higher strength?
            @strength = Math.random() * 20 | 0
            #Dodge chance? Max Speed?
            @agility = Math.random() * 20 | 0
            
        calculateHealth: ()->
            #Calculate current health based on age / resources
            health = @health

            #Subtract health if resources are scarce
            #slow, natural decay
            if @resources < 20
                health -= (0.01 + Math.abs(@resources * 0.01) )
                
            #happens faster if negative resources
            if @resources < 0
                health -= (0.2 + Math.abs(@resources * 0.04) )
                
            #if resources are high, more life
            if resources > 50
                health += (0.01 + Math.abs(@resources * 0.005) )

            return health
        
        calculateResources: ()->
            #Base resource consumption on age and other factors
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            resources = @resources
            
            #Resources decay naturally
            resources -= (0.05)
            return resources
            
    return Zombie
)
