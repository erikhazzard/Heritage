#============================================================================
#
#Systems - World 
#   Handles logic for updating game grid
#   TODO: Change the way this works, it's sort of acting like
#   a singleton in a sense
#
#============================================================================
define(['components/world'], (WorldComponent)->
    class World
        constructor: (entities)->
            @entities = entities
            WorldComponent.grid = {}
            return @

        #--------------------------------
        #
        #Helpers
        #
        #--------------------------------
        getGrid: ()->
            return WorldComponent.grid

        getCellFromPosition: (position)->
            #Gets cell i / j from position
            i = Math.floor(position.y / WorldComponent.cellSize)
            j = Math.floor(position.x / WorldComponent.cellSize)
            return [i,j]

        getNeighborsByCreatureType: (entity, entities, radius, requiredComponents)->
            #Get entities around this entity and return an object containing
            #  the counts for each type of neighbor
            neighbors = {zombie: [], human: []}
            requiredComponents = requiredComponents || false

            world = entity.components.world
            if not world
                return neighbors
 
            #Get neighbors
            for neighborId in world.getNeighbors(radius)
                #Don't add it to the neighbors if it doesn't have a combat component
                neighbor = entities.entities[neighborId]
                if not neighbor?
                    continue

                continueNeighborLoop = false

                #Don't add if it doesn't have the matched component
                if requiredComponents
                    for component in requiredComponents
                        if not neighbor.components[component]?
                            continueNeighborLoop = true

                if continueNeighborLoop
                    continue

                #Get all zombies around human, all humans around zombie
                if neighbor.hasComponent('zombie')
                    creatureType = 'zombie'
                else if neighbor.hasComponent('human')
                    creatureType = 'human'
                    
                if neighborId != entity.id and creatureType
                    neighbors[creatureType].push(neighborId)
                
            return neighbors
        
        #--------------------------------
        #
        #Tick
        #
        #-------------------------------- 
        tick: (delta)->
            #Reset the world grid
            WorldComponent.grid = {}

            #TODO: This way restricts us to only one world object 
            for id, entity of @entities.entitiesIndex['world']
                #Update the grid with this entity's position
                world = entity.components.world

                #Reset neighbors lookup each tick
                world.neighborsByRadius.length = 0
                
                #On each game tick, update the game world
                position = entity.components.position
                cell = @getCellFromPosition(position)
                
                #Update this cell's position
                i = cell[0]
                j = cell[1]
                world.i = i
                world.j = j
                
                #Add entity to the corresponding cell. NOTE: The grid is cleared 
                #  tick in the system.  TODO: Should this live in the system too?
                if WorldComponent.grid[i] == undefined
                    WorldComponent.grid[i] = {}
                if WorldComponent.grid[i][j] == undefined
                    WorldComponent.grid[i][j] = []
                
                if entity.id not in WorldComponent.grid[i][j]
                    WorldComponent.grid[i][j].push(entity.id)

            #Get each entity's neighbors
            #for id, entity of @entities.entitiesIndex['world']
                #entity.components.world.getNeighbors()
                
            return @
            
    return World
)
