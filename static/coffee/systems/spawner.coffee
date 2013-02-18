#============================================================================
#
#Systems - spawn
#   Handles logic to create new entities
#
#============================================================================
define(['entity'], (Entity)->
    class Spawner
        constructor: (entities)->
            @entities = entities
            return @
        
        #--------------------------------
        #
        #Helper function
        #
        #--------------------------------
        canBirth: (entity, neighbors)->
            #Looks at entity and returns true or false if it can birth
            #  a new entity
            human = entity.components.human
            
            if human.sex == 'male'
                #males can't become pregnant or give birth
                return false
            
            #Need some rules to prevent some entities from making babies
            #----------------------------
            if human.age < 20 or human.age > 64 or human.resources < 5
                return false
            
            #If it's pregnant, we can potentially make a baby!
            #----------------------------
            if human.isPregnant
                human.gestationTimeLeft -= 0.1
                
                #If it's time, a baby can be born
                #NOTE: This is the only true case
                #------------------------
                if human.gestationTimeLeft < 0
                    return true
                else
                    #A pregnant thing can't become pregnant
                    return false
                
            #Not pregnant, so let's try to make a baby
            #----------------------------
            
            #can't make a baby with itself
            if neighbors.length < 1
                return false
            else
                for neighbor in neighbors
                    #Only humans can give birth (for now)
                    if neighbor.hasComponent('human') != true
                        continue
                    
                    neighborHuman = neighbor.components.human
                    
                    #Rules for impregnanting - neighbor:
                    #must be male
                    if neighborHuman.sex == 'male'
                        #cannot be parent
                        #  but can be distantly related
                        parentIndex = neighborHuman.family.indexOf(entity.id)
                        if parentIndex > -1 and parentIndex < 6
                            return false
                        #or a child
                        if entity.id in neighborHuman.children
                            return false
                       
                        #Monogamus female 
                        if human.mateId != null and human.mateId != neighbor.id
                            #If the mateid doesn't exist, remove it
                            return false
                    
                        #Monogamus male
                        if neighborHuman.mateId == null
                            neighborHuman.mateId = entity.id
                        else if neighborHuman.mateId != entity.id
                            return false
                            
                        #We got a potenial baby daddy
                        if Math.random() < human.pregnancyChance
                            #initiate coitus 
                            human.isPregnant = true
                            human.mateId = neighbor.id
                            
                            #well, that was quick
                            break
                            
            #even if entity gets knocked up, it can't make a baby yet
            return false
        
        #--------------------------------
        #Make a baby
        #--------------------------------
        makeBaby: (entity, neighbors)->
            #Makes a new entity based on the parent entities
            human = entity.components.human
            
            #Reset the human's pregnancy status
            human.isPregnant = false
            human.gestationTimeLeft = human.gestationLength
            
            #Make a baby
            newEntity = new Entity()
            newEntity.addComponents(entity.getComponentNames())
            
            #Derive position from current entity position
            newEntity.components.position = entity.components.position.copy()
            newEntity.components.position = entity.components.position.copy()

            #Keep track of a family tree - entities can't inbreed
            newEntity.components.human.family.push(entity.id)
            newEntity.components.human.family.push(human.mateId)
            
            #add to the entities list
            @entities.add(newEntity)
            
            #Keep track of the children this entity has
            human.children.push(newEntity.id)
            
            #and the children for the father
            if @entities.entities[human.mateId]
                #make sure father still exists
                @entities.entities[human.mateId].components.human.children.push(newEntity.id)
            
            return newEntity

        #--------------------------------
        #Tick function
        #--------------------------------
        tick: (delta)->
            #Go through all spawners 
            #  For now, only humans can be spawners, but later we may have
            #  other creates (vampires, werewolves, etc)
            for id, entity of @entities.entitiesIndex['human']
                #Needs to be a human
                if entity.hasComponent('human') != true
                    continue

                #Birth?
                #   1. Can entity become pregnant
                #   2. Can entity give birth
                #------------------------
                neighbors = entity.components.world.neighbors
                canBirth = @canBirth(entity, neighbors)
                
                #Make a baby
                if canBirth
                    @makeBaby(entity)
                    
    
    return Spawner
)
