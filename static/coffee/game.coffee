define(['entity', 'entities', 'components/all', 'systems/all'], (Entity, Entities, Components, Systems)->
    class Game
        constructor: ()->
            #Set everything up
            
            #list of all entities
            #  entities are made up of an ID and collection of
            #  components
            @entities = new Entities()
            @systems = new Systems(@entities).systems
            @numTicks = 0
            @paused = false
        
            #add ability to pause - todo: put this somewhere else?
            document.addEventListener('keydown', (e)=>
                if e.keyCode == 32
                    #toggle paused
                    @paused = !@paused
                    #continue game loop if game is not paused
                    if !@paused
                        @gameLoop()
                else
                    @paused = false
            )
            
        start: ()->
            #Initialize stuff
            i=0
            while i < 35
                entity = new Entity()
                entity.addComponent('world')
                    .addComponent('position')
                    .addComponent('physics')
                    .addComponent('randomWalker')
                    .addComponent('renderer')
                    .addComponent('flocking')

                if Math.random() < 0.6
                    entity.addComponent('zombie')
                else
                    entity.addComponent('spawner')
                    entity.addComponent('human')
                    entity.components.human.age = Math.random() * 100 | 0
                    
                entity.components.position.x = Math.random() * 500 | 0
                entity.components.position.y = Math.random() * 500 | 0
                
                #entity.components.physics.velocity.x = Math.random() * 22 | 0
                #entity.components.physics.velocity.y = Math.random() * 22 | 0
                @entities.add( entity )
                
                i++
                
            @gameLoop()
            
            #For debug / performance
            #setInterval(()=>
                #console.log('Ticks after 1 sec: ' + @numTicks)
            #, 1000)

        #--------------------------------
        #Game Loop stuff
        #--------------------------------
        gameLoop: ()=>
            if @paused
                return true
            
            #This is the main game loop
            requestAnimFrame(@gameLoop)
            #setTimeout(()=>
                #requestAnimFrame(@gameLoop)
            #, 200)
            
            #Go through all systems and call tick if it has it
            for system in @systems
                if system.tick
                    system.tick(@numTicks)
                    
            @numTicks += 1
    
    return Game
)
