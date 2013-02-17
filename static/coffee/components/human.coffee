#============================================================================
#
#Human component
#   Defines human component - defines life, resources, age, etc
#
#   TODO: Should human / zombie / etc assume creature component exists, or
#   manually create it?
#
#   Dependencies / Coupling:
#
#============================================================================
define([], ()->
    class Human
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            #When health < 0, entity dies
            @health = params.health || 100
            #Age increases by 0.1 each tick
            @age = params.age || 0.1
            
            #Resources is an abstraction to represent food
            @resources = params.resources || 100

            #Either male or female
            @sex = ['male', 'female'][Math.random() * 2 | 0]
            #If entity is a female, it can only create a new entity if
            #  is it's not pregnant
            #  When it is pregnant, it uses twice the amount of resources
            #NOTE: These are not used if entity is male
            @isPregnant = false
            @pregnancyChance = Math.round(Math.random() * 100) / 100
            @gestationLength = 0.9
            #when entity is pregnant, this is set to gestationLength
            #  and descreased by 0.1 each tick
            @gestationTimeLeft = 0
            #ID of entity that impregnated this entity
            @mateId = null
            
            #Keep track of children this entity has birthed
            @children = []
            @family = []

            #When health falls below 0, it's dead
            @isDead = false
            
            #----------------------------
            #Stats
            #----------------------------
            @strength = Math.random() * 20 | 0
            #Dodge chance? Max Speed?
            @agility = Math.random() * 20 | 0
            
        calculateHealth: ()->
            #Calculate current health based on age / resources
            health = @health

            #Subtract health if resources are scarce
            if @resources < 0
                health -= (0.1 + Math.abs(@resources * 0.02) )
                
            #If entity is old, subtract health
            if @age > 70
                health -= (0.1 + (@age * 0.005))
                
            if @age > 100
                #much greater chance of death older entity is
                if Math.random() < 0.1
                    health = -1
                
            return health

        calculateResources: ()->
            #Base resource consumption on age and other factors
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            resources = @resources
            
            if @age < 20
                #young
                resources -= (0.05 + ((20 - @age)/26))
            else if @age > 60
                #old
                resources -= (0.2 + (@age * 0.001))
            else
                #normal resource depletion rate
                resources -= 0.10
                
                #If it's pregnant, use more resources
                if @isPregnant
                    resources -= 0.10

            return resources
        
        getMaxSpeed: ()->
            #Returns the max speed for the entity. Used in the system
            #TODO: base this off agility and injuries and whatnot
            maxSpeed = 0
            
            if @age < 2
                maxSpeed = 2
            else if @age < 10
                maxSpeed = 4
            else if @age < 60
                maxSpeed = 6 + (Math.random() * 4 | 0)
            else
                maxSpeed = 4
                
            return maxSpeed

    return Human
)
