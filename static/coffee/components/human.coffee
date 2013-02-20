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
define(['lib/d3'], (d3)->
    class Human
        constructor: (entity, params)->
            params = params || {}
            @entity = entity

            #Age increases by 0.1 each tick
            @age = params.age || 0.1
            #Keep track if human is dead - other components might
            # have different requirement for death
            @isDead = false
            
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
            
            #----------------------------
            #effects
            #----------------------------
            @hasZombieInfection = false
            @infectionScale = d3.scale.linear()
                .domain([0, 100])
                .range([0.3,0.001])
                .clamp(true)
            
            #----------------------------
            #Stats
            #----------------------------
            @strength = Math.random() * 20 | 0
            #Dodge chance? Max Speed?
            @agility = Math.random() * 20 | 0
            
        calculateHealth: (health)->
            #Calculate health based on passed in health and
            #NOTE: uses the health component, called from the system

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

            #If it has an infection, decrease health
            if @hasZombieInfection
                health -= 5
                
            return health
        
        getIsDead: (health)->
            if health <= 0
                @isDead = true
            return @isDead
        
        getInfectionChance: (health, damageTaken)->
            #Lower health is, higher chance for infection
            #Older age, higher infection chance
            chance = @infectionScale(health)
            if @age > 70
                chance += 0.2
                
            chance += (damageTaken * 0.001)
            return chance

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
                #In it's prime, normal max speed
                maxSpeed = 8
                
            else if @age < 70
                maxSpeed = 3
            else
                maxSpeed = 2
                
            return maxSpeed

    return Human
)
