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
                #Don't add it to the neighbors if it doesn't have a combat component
                if not neighbor.hasComponent('combat')
                    continue
                
                #Get all zombies around human, all humans around zombie
                if neighbor.hasComponent('zombie')
                    creatureType = 'zombie'
                else if neighbor.hasComponent('human')
                    creatureType = 'human'
                    
                if neighbor != entity and creatureType
                    neighbors[creatureType].push(neighbor)
                
            return neighbors
        
        checkCanAttack: (combat)->
            #First, update the attack speed counter
            if not combat.canAttack
                combat.attackTicksRemaining -= 1
                if combat.attackTicksRemaining <= 0
                    combat.canAttack = true
                    combat.attackTicksRemaining = combat.attackDelay

            return combat.canAttack
        
        calculateDamage: (entity, enemyEntity)->
            #Calculate damage to take based on the passed in combat
            #  components of the target entity and enemy entity
            damageTaken = 0
            
            #get the attack value for the enemy entity
            enemyDamage = enemyEntity.attack
            damageTaken += enemyDamage

            #Subtract the enemy attack damage with the entity's defense
            damageTaken -= entity.defense
            
            #Never return a negative number
            if damageTaken < 0
                damageTaken = 0
                
            #Enemey attacked, so don't let them attack again until timer is 
            #   reached
            enemyEntity.canAttack = false
            enemyEntity.attackTicksRemaining = enemyEntity.attackDelay
            
            return damageTaken
            
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
                #store ref to combat component
                combat = entity.components.combat
                @checkCanAttack(combat)
                
                if isHuman or isZombie
                    neighbors = @getNeighbors(entity)
                    #Fight between entities - but only fight one at a time 
                    #  The more of the same type of entities around this entity,
                    #  the strong it is
                    
                    #HUMAN vs Zombie
                    #--------------------
                    #Small bits of logic - go after the weakest enemy
                    if isHuman and neighbors.zombie.length > 0
                        #should slow down when in fight
                        entity.components.physics.velocity.multiply(0.05)
                        #store refs
                        health = entity.components.health
                        human = entity.components.human
                        
                        #For each enemy in range, calculate how much damage the
                        #   enemy will do to the entity
                        for zombie in neighbors.zombie
                            #------------
                            #figure out how much damage to take
                            #------------

                            #Calculate damage taken
                            damageTaken = @calculateDamage(combat, zombie.components.combat)

                            #Decrease entity's health
                            health.health -= damageTaken
                            
                            #Chance for human to get infected
                            if damageTaken > 0
                                if Math.random() < human.getInfectionChance(health.health, damageTaken)
                                    human.hasZombieInfection = true
                        
                    #ZOMBIE vs Human
                    #--------------------
                    else if isZombie and neighbors.human.length > 0
                        entity.components.health.health -= 10

                        #should slow down when in fight
                        entity.components.physics.velocity.multiply(0.01)

            
            #TODO: RESOLVE DAMAGE ON STACK

            return @
            
    return Combat
)
