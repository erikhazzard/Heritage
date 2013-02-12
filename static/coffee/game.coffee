define(['entity', 'entities', 'systems/all'], (Entity, Entities, Systems)->
    class Game
        constructor: ()->
            #Set everything up
            
            #list of all entities
            #  entities are made up of an ID and collection of
            #  components
            @entities = new Entities()
            @systems = Systems
            
        start: ()->
            #Initialize stuff
            @loop()

        #--------------------------------
        #Game Loop stuff
        #--------------------------------
        loop: ()=>
            #This is the main game loop
            requestAnimFrame(@loop)
    
    return Game
)
