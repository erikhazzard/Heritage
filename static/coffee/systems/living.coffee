#============================================================================
#
#Systems - Living (Think of better name?)
#   Handles logic to keep an entity 'alive'
#
#   components used:
#       human
#       physics
#============================================================================
define(['entity'], (Entity)->
    class Living
        constructor: (entities)->
            @entities = entities
            return @

        #--------------------------------
        #Update helpers
        #--------------------------------
        updateHuman: (entity)->
            #During each tick, update properties based on current properties
            human = entity.components.human
            physics = entity.components.physics
            
            #Update age
            human.age += 0.1
            
            physics.maxSpeed = human.getMaxSpeed()
            
            #update resources
            human.resources = human.calculateResources()
            
            #Update health
            human.health = human.calculateHealth()
            if human.health < 0
                human.isDead = true
            
            #If human is dead and infected it should create a zombie
            #------------------------
            if human.isDead and human.hassZombieInfection
                newZombie = new Entity()
                    .addComponent('world')
                    .addComponent('position')
                    .addComponent('physics')
                    .addComponent('randomWalker')
                    .addComponent('renderer')
                    .addComponent('flocking')
                    .addComponent('zombie')
                    
                newZombie.components.position = entity.components.position.copy()
                @entities.add(newZombie)
                
            #If the entity is dead, remove it
            #------------------------
            if human.isDead
                @entities.remove(entity)
        
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
    
    return Living
)
