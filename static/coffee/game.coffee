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
            i=0
            while i<29
                entity = new Entity()
                entity.addComponent('world')
                    .addComponent('position')
                    .addComponent('physics')
                    .addComponent('randomWalker')
                    .addComponent('flocking')
                    .addComponent('renderer')
                    
                entity.components.position.x = Math.random() * 400 | 0
                entity.components.position.y = Math.random() * 400 | 0
                #entity.components.physics.velocity.x = Math.random() * 22 | 0
                #entity.components.physics.velocity.y = Math.random() * 22 | 0
                @entities.add( entity )
                
                i++
                
            @loop()
            
            #For debug / performance
            #setInterval(()=>
                #console.log('Ticks after 1 sec: ' + @numTicks)
            #, 1000)

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
