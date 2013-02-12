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
            
        start: ()->
            #Initialize stuff
            @entities.add( new Entity() )
                .addComponent('vector')
                .addComponent('renderer')
                
            @loop()
            
            #For debug / performance
            setInterval(()=>
                console.log('Ticks after 1 sec: ' + @numTicks)
            , 1000)

        #--------------------------------
        #Game Loop stuff
        #--------------------------------
        loop: ()=>
            #This is the main game loop
            requestAnimFrame(@loop)
            
            #Go through all systems and call tick if it has it
            for systemName, system of @systems
                if system.tick
                    system.tick(@numTicks)
                    
            @numTicks += 1
    
    return Game
)
