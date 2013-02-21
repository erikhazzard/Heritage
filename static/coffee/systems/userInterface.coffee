#============================================================================
#
#Systems - Interface
#   Handles interaction with the game world
#   TODO: communication between systems using system manager
#
#============================================================================
define(['components/vector', 'components/world'], (Vector, World)->
    #TODO: Abstract this better to allow multiply canvases
    canvas = document.getElementById('canvas')
    
    class UserInterface
        constructor: (entities)->
            @entities = entities
            #Create mouse vector
            @mouse = new Vector(0,0)
            @$debug = document.getElementById('debug')
            
            #Setup event listener to update mouse
            canvas.addEventListener('mousemove', (e)=>
                @mouse.x = e.clientX
                @mouse.y = e.clientY
            )

            return @
        
        getEntitiesUnderMouse: (e)->
            #Returns the entity(ies) under the mouse
            #Get mouse x,y
            cell = World.prototype.getCellFromPosition(@mouse)
            grid = World.grid
            html = ''

            if grid[cell.i] and grid[cell.i][cell.j]
                entities = grid[cell.i][cell.j]
                
                #Let renderer know the entity is selected
                for entity in entities
                    if entity and entity.hasComponent('renderer')
                        entity.components.renderer.isSelected = true
                        
                    #Update html
                    html = 'ID: ' + entity.id
                    if entity.hasComponent('human')
                        html += '<br />' + entity.components.human.age
                        html += '<br />' + entity.components.human.children.length
                        html += '<br />' + entity.components.human.mateId
                        
            if entities
                @$debug.innerHTML = html
                
            return entities
        
        showUserMovableInfo: ()->
            html = ''
            entities = @entities.entitiesIndex.userMovable
            
            for key, entity of entities
                html = 'ID: ' + entity.id
                html += '<br />Health: ' + entity.components.health.health
                html += '<br />Resources: ' + entity.components.resources.resources
                if entity.hasComponent('human')
                    html += '<br />Age: ' + entity.components.human.age
                    html += '<br />Mate: ' + entity.components.human.mateId
                    html += '<br />Infected:' + entity.components.human.hasZombieInfection
                
            @$debug.innerHTML = html
                    
            return entities
        
        tick: (delta)->
            #@getEntitiesUnderMouse()
            #Show info for user movable entity
            @showUserMovableInfo()
            return @
        
    return UserInterface
)
