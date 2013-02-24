#============================================================================
#
#World component
#   Defines the world the entities live on. 
#       Namely, the width / height of the world and the canvas context
#
#   TODO: Should this be something, or maybe live somewhere else? Lots of
#   coupling going on here
#   Should entities automatically get this?
#   TODO: Listen for position change event?
#
#   Dependencies / Coupling:
#       entity
#
#============================================================================
define([], ()->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    canvasWidth = canvas.width
    canvasHeight = canvas.height
    
    
    class World
        #NOTE: This isn't the best way to do this - this will allow us to
        #  use only one world
        @width = canvasWidth * 4
        @height = canvasHeight * 4
        @canvas = canvas
        @context = context
        
        #GRID
        #NOTE: grid is reset each tick in the World system
        @grid = {}
        @cellSize = 2
        @rows = canvasHeight / @cellSize
        @columns= canvasWidth / @cellSize

        constructor: (entity, params)->
            #By default, we'll use the passed in canvas above.
            #  Keep in mind extensibility though, as we may want
            #  to have multiple 'worlds'
            params = params || {}
            @entity = entity
            @width = params.width || World.width
            @height = params.height || World.width
            @canvas = params.canvas || World.canvas
            @context = params.context || World.context
            @neighbors = []
            
            #World config
            return @
        
        getNeighbors: (radius)->
            #TODO: This probably shouldn't live here
            #Gets the cells in a radius around this cell
            radius = radius || 1
            neighbors = []
            
            #Loop through neighboring cells to get entities
            #  We do this because it's more efficient to loop through only
            #  25 cells for each entity as opposed to each entity
            for i in [-radius..radius] by 1
                for j in [-radius..radius] by 1
                    targetI = @i + i
                    targetJ = @j + j
                    
                    #Wrap around, make sure it's in range
                    #I
                    if targetI > World.rows
                        targetI = targetI % World.rows
                    if targetI < 0
                        targetI = World.rows + targetI
                    #J
                    if targetJ > World.columns
                        targetJ = targetJ % World.columns
                    if targetJ < 0
                        targetJ = World.columns + targetJ
                        
                    if World.grid[targetI] and World.grid[targetI][targetJ]
                        targetEntities = World.grid[targetI][targetJ]
                        #Target
                        for entity in targetEntities
                            if entity.id != @entity.id
                                neighbors.push(entity)
                
            @neighbors = neighbors
            return neighbors

        getCellFromPosition: (position)->
            i = Math.floor(position.y / World.cellSize)
            j = Math.floor(position.x / World.cellSize)
            return {i: i, j:j}

        tick: (delta)->
            #On each game tick, update the game world
            position = @entity.components.position
            cell = @getCellFromPosition(position)
            
            #Update this cell's position
            @i = cell.i
            @j = cell.j
            
            #Add entity to the corresponding cell. NOTE: The grid is cleared 
            #  tick in the system.  TODO: Should this live in the system too?
            if World.grid[@i] == undefined
                World.grid[@i] = {}
            if World.grid[@i][@j] == undefined
                World.grid[@i][@j] = []
            
            World.grid[@i][@j].push(@entity)
    
    return World
)
