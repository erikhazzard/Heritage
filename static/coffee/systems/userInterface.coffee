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
            #TODO: This doesn't work right now
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
                
            @$debug.innerHTML += html
                    
            return entities

        showEntityInfo: ()->
            #Show counts of entities
            @$debug.innerHTMl += '<br /><br />Entity Info'
            @$debug.innerHTML += '<br />Humans: ' + Object.keys(
                @entities.entitiesIndex.human).length
            @$debug.innerHTML += '<br />Zombies: ' + Object.keys(
                @entities.entitiesIndex.zombie).length + '<br />'
            return true

        
        tick: (delta)->
            @$debug.innerHTML = ''

            #@getEntitiesUnderMouse()
            @showEntityInfo()
            #Show info for user movable entity
            @showUserMovableInfo()
            return @
        
    return UserInterface
)
