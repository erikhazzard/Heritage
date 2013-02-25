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
        @cellSize = 4
        @rows = Math.floor(@height / @cellSize)
        @columns= Math.floor(@width / @cellSize)

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
            @neighborsByRadius = []
            
            #World config
            return @
        

        getNeighbors: (radius)->
            #If the neighborsByRadius object exists for the radius, return it
            #  otherweise create it

            #Check radius
            if radius?
                radius = radius
            else
                radius = 1
            #If it's negative, set it to 0
            if radius < 1
                radius = 0

            #Try to lookup neighbors
            neighbors = []
            if @neighborsByRadius[radius]
                neighbors = @neighborsByRadius[radius]
            else
                #Get neighbors and update lookup
                neighbors = @calculateNeighbors(radius)
                @neighborsByRadius[radius] = neighbors

            return neighbors

        calculateNeighbors: (radius)->
            #TODO: This probably shouldn't live here
            #Gets the cells in a radius around this cell
            neighbors = []
                
            #If radius is less than 1, only check for entities
            #  in the same cell as this entity
            if radius == 0
                if World.grid[@i] and World.grid[@i][@j]
                    targetEntities = World.grid[@i][@j]
                    #Target
                    for entityId in targetEntities
                        if entityId != @entity.id
                            neighbors.push(entityId)
            
            else
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
                            for entityId in targetEntities
                                if entityId != @entity.id
                                    #make sure the ID has not been added
                                    if entityId not in neighbors
                                        neighbors.push(entityId)
                     
            return neighbors

    return World
)
