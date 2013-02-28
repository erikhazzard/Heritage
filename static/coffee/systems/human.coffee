#============================================================================
#
#Systems - Living (Think of better name?)
#   Handles logic to keep an entity 'alive'
#
#   components used:
#       human
#
#   OVERVIEW:
#       Human will age lose health quickly as human ages
#       Will get more health slowly over time.
#       Will increase attack and defense slowly after taking or receiving
#         damage
#       Can make babies (spawner class)
#       Can get a zombie infection (based on damage received and mitigated
#           by defense)
#       When dies, if entity is user controlled, will pass control to a
#           child
#
#   #TODO: CONSISTENT NEIGHBOR INTERFACE
#============================================================================
define(['entity', 'assemblages/assemblages', 'systems/world'], (Entity, Assemblages, WorldSystem)->
    class Living
        constructor: (entities)->
            @entities = entities
            return @

        #--------------------------------
        #
        #Update helpers
        #
        #--------------------------------
        calculateResources: (entity, neighbors)->
            #Base resource consumption on age and other factors
            #  TODO: Other factors.  higher strength, higher resource
            #  comsumption
            resources = entity.components.resources.resources
            
            human = entity.components.human
            if human.age < 20
                #young
                resources -= (0.005 + ((20 - human.age)/46))
            else if @age > 60
                #old
                resources -= (0.1 + (human.age * 0.0005))
            else
                #normal resource depletion rate
                resources -= 0.01
                #If it's pregnant, use more resources
                if human.isPregnant
                    resources -= 0.05
                    
            ##Higher resource consumpation based on number of neighbors
            resources -= ((neighbors.length) * 0.08)
                
            return resources
        
        calculateHealth: (entity)->
            #Calculate health based on passed in health and
            #NOTE: uses the health component, called from the system
            human = entity.components.human
            resources = entity.components.resources.resources
            health = entity.components.health.health

            #Testing how behavior works if resources aren't involved
            ##Subtract health if resources are scarce
            #if resources < 0
                #health -= (0.1 + Math.abs(resources * 0.02) )
                
            ##If entity is old, subtract health
            if human.age > 70
                health -= (0.1 + (human.age * 0.005))
                
            if human.age > 100
                #much greater chance of death older entity is
                if Math.random() < 0.1
                    health = -1
            health += 0.01

            #If it has an infection, decrease health
            if human.hasZombieInfection
                health -= 5
                
            return health
        
        updateMaxSpeed: (entity, neighbors)->
            #Returns the max speed for the entity. Used in the system
            #TODO: base this off agility and injuries and whatnot
            physics = entity.components.physics
            human = entity.components.human
            maxSpeed = 0
            
            if human.age < 2
                maxSpeed = 3
            else if human.age < 10
                maxSpeed = 5
                
            else if human.age < 60
                #In it's prime, normal max speed
                maxSpeed = 8
                
            else if human.age < 70
                maxSpeed = 4
            else
                maxSpeed = 3
                
            #TODO: should this go here...
            maxSpeed = maxSpeed - (neighbors.length * 0.9)
            if maxSpeed < 0
                maxSpeed = 1
                
            #Set max force
            maxForce = 0.5 - (neighbors.length * 0.1)
            
            #Set speed based on health
            if human.health < 50
                maxSped -= (1 / (human.health * 0.1))
            
            #Set components
            physics.maxSpeed = maxSpeed
            physics.maxForce = maxForce
            
            return maxSpeed
        
        updateCombatProperties: (entity, neighbors)->
            #Update various combat component properties
            human = entity.components.human
            combat = entity.components.combat
                
            #Update combat stats based on damage done / recieved
            if combat.damageTaken
                for damage in combat.damageTaken
                    #damage is in format of [entity, damageAmount]
                    combat.baseDefense += (damage[1] * 0.005)
                    
            if combat.damageDealt
                for damage in combat.damageDealt
                    #damage is in format of [entity, damageAmount]
                    combat.baseAttack += (damage[1] * 0.002)
            
            #Update combat stats based on age
            if human.age <= 10
                combat.attack = combat.baseAttack / (human.age * 0.1)
                combat.defense = combat.baseDefense / (human.age * 0.1)
            else if human.age > 70
                combat.attack = combat.baseAttack - ((human.age - 70) * 0.2)
                combat.defense = combat.baseDefense - ((human.age - 70) * 0.2)
            else
                combat.attack = combat.baseAttack
                combat.defense = combat.baseAttack
                
            #More neighbors there are, the more defense and attack entity has
            combat.defense += (((neighbors.length * neighbors.length) * 0.05) * 1)
            combat.attack += (neighbors.length * 0.8)
            
            return true

        updateZombieInfection: (entity, neighbors)->
            #If the entity was damaged, there's a chance for infection
            combat = entity.components.combat
            human = entity.components.human
            health = entity.components.health
            human.hasZombieInfection = false
            
            #Healthier entity is, less chance it has for infection
            if health
                #Can only get infection if damage was done
                if combat and combat.damageTaken.length > 0
                    chance = human.infectionScale(health.health)
                    if @age > 70
                        chance += 0.5
                    #Decrease chance based on defense
                    chance -= combat.defense * 0.03
                    #more zombies around, more chance
                    chance += (neighbors.zombie.length * 0.01)
                    
                    #For each damage taken, calculate infection chance
                    for damage in combat.damageTaken
                        chance += (damage[1] * 0.05)
                        if Math.random() < chance
                            human.hasZombieInfection = true
                            #keep track of who infected human
                            human.zombieInfector = damage[0]
                            #Keep track of this entity the zombie infects
                            @entities.entities[human.zombieInfector].components.zombie.humansInfected.push(
                                entity.id
                            )
                        
            return human.hasZombieInfection
        #--------------------------------
        #
        #Update logic
        #
        #--------------------------------
        updateHuman: (entity)->
            #During each tick, update properties based on current properties
            
            #Store references
            human = entity.components.human
            physics = entity.components.physics
            health = entity.components.health
            resources = entity.components.resources
            combat = entity.components.combat
            
            #update properties
            human.age += human.ageSpeed
            
            #TODO: HACK: Use world cell caching
            neighbors = WorldSystem.prototype.getNeighborsByCreatureType(
                entity, @entities, 4, ['world']
            )
            
            if physics
                #Do stuff based on neighbors
                @updateMaxSpeed(entity, neighbors.human)
            
            #Get resources
            resources.resources = @calculateResources(entity, neighbors.human)
            
            if combat
                @updateCombatProperties(entity, neighbors.human)
                #Check for chance of infection
                @updateZombieInfection(entity, neighbors)
            
            #If entity is low on resources, make it not flock together so much
            if resources < 10
                #chance they will want to seek resources on their own
                if Math.random() < 0.05
                    entity.components.flocking.rules.cohesion = -1
                    entity.components.flocking.rules.align = -1
                
            health.health = @calculateHealth(entity)
            
            #is the human dead?
            human.isDead = human.getIsDead(health.health)
            
            #------------------------
            #If human is dead and infected it should create a zombie
            #------------------------
            if human.isDead and human.hasZombieInfection
                #Create a zombie from this human
                newZombie = Assemblages.zombie()
                newZombie.components.position.x = entity.components.position.x
                newZombie.components.position.y = entity.components.position.y
                
                @entities.add(newZombie)

                #Turn entity to a zombie
                if entity.hasComponent('userMovable')
                    newZombie.addComponent('userMovable')
                    @entities.PC = newZombie.id
                
            #If the entity is dead, remove it
            #------------------------
            if human.isDead
                
                #Transfer control a child
                if not human.hasZombieInfection and entity.hasComponent('userMovable') and human.children
                    i = 0
                    len = human.children.length
                    while i < len
                        if human.children[i]
                            child = @entities.entities[ human.children[i] ]
                            if child and child.hasComponent('human') and not child.components.human.isDead
                                child.addComponent('userMovable')
                                @entities.PC = child.id
                            break

                #TODO: remove from children and family arrays
                @entities.remove(entity)
                
            return true

        #--------------------------------
        #
        #tick
        #
        #--------------------------------
        tick: (delta)->
            #Go through all creatures (note: humans, zombies, etc. all have
            #  a creature component)
            for id, entity of @entities.entitiesIndex['human']
                @updateHuman(entity)
    
            return @
        
    return Living
)
