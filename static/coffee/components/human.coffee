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

            #Age increases by some amount each tick (set in Living system)
            @age = params.age || 0.1
            @ageSpeed = params.ageSpeed || 0.1
            
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
            @pregnancyChance = Math.random()
            @findMateChance = Math.random()
            
            @gestationLength = 0.9
            #when entity is pregnant, this is set to gestationLength
            #  and descreased by some number each tick
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

    return Human
)
