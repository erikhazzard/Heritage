#============================================================================
#
#Systems - Living (Think of better name?)
#   Handles logic to keep an entity 'alive'
#
#   components used:
#       human
#       physics
#============================================================================
define(['entity', 'assemblages/assemblages'], (Entity, Assemblages)->
    class Living
        @ageSpeed = 0.07

        constructor: (entities)->
            @entities = entities
            return @

        #--------------------------------
        #
        #Update helpers
        #
        #--------------------------------
        calculateResources: (entity)->
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
                    
            #Higher resource consumpation based on number of neighbors
            neighbors = entity.components.world.neighbors
            if neighbors.length > 1
                resources -= ((neighbors.length * neighbors.length) * 0.08)
                
            return resources
        
        calculateHealth: (entity)->
            #Calculate health based on passed in health and
            #NOTE: uses the health component, called from the system
            human = entity.components.human
            resources = entity.components.resources.resources
            health = entity.components.health.health

            #Subtract health if resources are scarce
            if resources < 0
                health -= (0.1 + Math.abs(resources * 0.02) )
                
            #If entity is old, subtract health
            if human.age > 70
                health -= (0.1 + (human.age * 0.005))
                
            if human.age > 100
                #much greater chance of death older entity is
                if Math.random() < 0.1
                    health = -1

            #If it has an infection, decrease health
            if human.hasZombieInfection
                health -= 5
                
            return health
        
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
            
            #update properties
            human.age += Living.ageSpeed
            physics.maxSpeed = human.getMaxSpeed()
            resources.resources = @calculateResources(entity)
            
            #If entity is low on resources, make it not flock together so much
            if resources < 10
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
                    
                #Turn entity to a zombie
                if entity.hasComponent('userMovable')
                    newZombie.addComponent('userMovable')
                    
                newZombie.components.position.x = entity.components.position.x
                newZombie.components.position.y = entity.components.position.y
                @entities.add(newZombie)
                
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
