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
                if entity.components.health
                    html += '<br />Health: ' + entity.components.health.health
                html += '<br />Resources: ' + entity.components.resources.resources
                if entity.hasComponent('human')
                    html += '<br />Age: ' + entity.components.human.age
                    html += '<br />Mate: ' + entity.components.human.mateId
                    html += '<br />Infected:' + entity.components.human.hasZombieInfection
                if entity.hasComponent('combat')
                    html += '<br />Attack: ' + entity.components.combat.attack
                    html += '<br />Defense: ' + entity.components.combat.defense
                    html += '<br />AttackCounter: ' + entity.components.combat.attackCounter
                    html += '<br />Delay: ' + entity.components.combat.attackDelay
                    html += '<br />Target: ' + entity.components.combat.target
                    html += '<br />Range: ' + entity.components.combat.range

                if entity.hasComponent('world')
                    html += '<hr />'
                    html += '<br />Position'
                    html += '<br />X: ' + entity.components.position.x
                    html += '<br />Y: ' + entity.components.position.y

                    html += '<br /><br />World'
                    html += '<br />I: ' + entity.components.world.i
                    html += '<br />J: ' + entity.components.world.j
                    
                combat = entity.components.combat
                if combat and combat.damageTaken.length > 0
                    console.log('HIT! Damage taken for Entity:', entity.id)
                    for item in combat.damageTaken
                        console.log(item[0], item[1])
                
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
