define(['entity', 'entities', 'components/all', 'systems/all', 'assemblages/assemblages', 'lib/d3'], (
    Entity, Entities, Components, Systems, Assemblages, d3)->
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

            entity = Assemblages.human()
            entity.addComponent('userMovable')
            entity.components.position.x = 250
            entity.components.position.y = 250
            entity.components.human.age = 20
            @entities.add(entity)
            
            while i < 50
                if Math.random() < 0.3
                    entity = Assemblages.zombie()
                    entity.components.combat.attack = Math.random() * 10 | 0
                    entity.components.combat.defense = Math.random() * 5 | 0
                else
                    entity = Assemblages.human()
                    entity.components.human.age = d3.random.normal(20,10)()
                    
                entity.components.position.x = Math.random() * 500 | 0
                entity.components.position.y = Math.random() * 500 | 0
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
