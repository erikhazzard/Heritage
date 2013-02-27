#============================================================================
#
#Systems - spawn
#   Handles logic to create new entities
#
#   -Components: Human
#
#   TODO: Should this be rolled into the human system? Or should there be
#   a spawner component instead? Or maybe this is a subsystem of human?
#
#============================================================================
define(['entity', 'systems/human'], (Entity, Human)->
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
            #  Will return either true or false
            #TODO: SPLIT THIS FUNCTION UP
            human = entity.components.human
            resources = entity.components.resources.resources
            
            if human.sex == 'male'
                #males can't become pregnant or give birth
                return false
            
            #If it's pregnant, we can potentially make a baby!
            #----------------------------
            if human.isPregnant
                human.gestationTimeLeft -= Human.ageSpeed
                
                #If it's time, a baby can be born
                #NOTE: This is the only true case
                #------------------------
                if human.gestationTimeLeft < 0
                    return true
    
            #even if entity gets knocked up, it can't make a baby yet
            return false
        
        #--------------------------------
        #Attempt conception
        #--------------------------------
        conceive: (entity, neighbors)->
            #Try to impregnante entity
            human = entity.components.human
            resources = entity.components.resources.resources
           
            if human.isPregnant
                return true

            if human.sex == 'male' or human.age < 20 or human.age > 64 or resources < 15
                return false

            if human.mateId?
                if neighbors.indexOf(human.mateId) > -1
                    if Math.random() < human.pregnancyChance
                        #impregnante it
                        human.isPregnant = true
                        human.gestationTimeLeft = human.gestationLength

            return human.isPregnant

        #--------------------------------
        #Find a mate
        #--------------------------------
        findMate: (entity, neighbors)->
            human = entity.components.human

            #If it has a mate, return false
            if human.mateId?
                return false
            
            #Find a mate for this entity
            for neighborId in neighbors
                neighbor = @entities.entities[neighborId]
                if not neighbor?
                    continue

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
                        continue
                    #or a child
                    if entity.id in neighborHuman.children
                        continue

                    #TODO: If mate dies, allow them to mate with another
                    #Monogamus female 
                    if human.mateId != null and human.mateId != neighbor.id
                        continue
                
                    #Monogamus male
                    if not neighborHuman.mateId?
                        #Some chance that they become mates
                        if Math.random() < human.findMateChance
                            neighborHuman.mateId = entity.id
                            human.mateId = neighbor.id
                        else
                            continue
                        
                    else if neighborHuman.mateId != entity.id
                        continue
                    
            return human.mateId?
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
            #Inherit parent components
            newEntity.addComponents(entity.getComponentNames())
            if newEntity.hasComponent('userMovable')
                newEntity.removeComponent('userMovable')
            
            #Derive position from current entity position
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
                #1. Check to see if canBirth is true. If so, make a baby.
                #2. Check to see if entity has a mate. If not, try to find one
                #3. If entity has a mate, and is not pregnant, try to conceive
                #NOTE: not far enough
                
                neighbors = entity.components.world.getNeighbors(3)
                canBirth = @canBirth(entity, neighbors)

                #Make a baby
                if canBirth
                    @makeBaby(entity)
                    continue
                
                #find a mate for this entity if it doesn't have one
                @findMate(entity, neighbors)
                @conceive(entity, neighbors)
                
                    
            return @
    
    return Spawner
)
