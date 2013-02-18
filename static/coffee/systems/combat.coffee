#============================================================================
#
#Systems - Combat
#   Simulates fighting between entities
#
#============================================================================
define([], ()->
    class Combat
        constructor: (entities)->
            @entities = entities
            return @
        
        getNeighbors: (entity)->
            #Get entities around this entity and return an object containing
            #  the counts for each type of neighbor
            neighbors = {zombie: [], human: []}
            
            #Get neighbors
            for neighbor in entity.components.world.getNeighbors(entity.components.combat.range)
                #Get all zombies around human, all humans around zombie
                if neighbor.hasComponent('zombie')
                    creatureType = 'zombie'
                else if neighbor.hasComponent('human')
                    creatureType = 'human'
                    
                if neighbor != entity
                    neighbors[creatureType].push(neighbor)
                
            return neighbors
                
        #--------------------------------
        #
        #Tick
        #
        #--------------------------------
        tick: (delta)->
            #Look at each entity, then get its neighbors, then fight
            #  (for now, only humans vs. zombies fight. Later, we can do
            #  human v human but keep it simple now)
            #
            #The fight() function is called with two entities and
            #  damage is put onto the stack as {entityId: damage}
            #
            #After the inital look through is complete, look at each
            #  item in the stack and resolve the damage.
            #
            #
            #NOTES: An entity can only fight one other entity at a time
            
            #keep track of damage to deal. in form of 
            damageStack = []
            
            for id, entity of @entities.entitiesIndex['combat']
                isHuman = entity.hasComponent('human')
                isZombie = entity.hasComponent('zombie')
                
                if isHuman or isZombie
                    neighbors = @getNeighbors(entity)
                    #Fight between entities - but only fight one at a time 
                    #  The more of the same type of entities around this entity,
                    #  the strong it is
                    
                    #HUMAN vs Zombie
                    #--------------------
                    #Small bits of logic - go after the weakest enemy
                    if isHuman and neighbors.zombie.length > 0
                        entity.components.health.health = 10
                        entity.components.human.resources = 0
                        entity.components.human.hasZombieInfection = true
                        
                    #ZOMBIE vs Human
                    #--------------------
                    else if isZombie and neighbors.human.length > 0
                        entity.components.health.health = 10
                        entity.components.zombie.resources += 20

            return @
            
    return Combat
)
