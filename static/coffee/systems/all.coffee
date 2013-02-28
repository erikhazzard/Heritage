#============================================================================
#
#Systems - All
#   Loads all the systems and returns an object containing all system names
#   and systems
#
#
#INTERFACE:
#   When called, pass in an entities object (normally, this is ALL entities)
#       returns an object of key:value pairs of systemName: systemObject
#
#System Class Interface
#   -Each system class must take in entities as an argument in its constructor
#   -Each system must provide a tick() method if it wishes to be called inside
#       the game loop, and can may accept a delta argument
#============================================================================
define([
    'systems/userMovable',
    'systems/flocking',
    'systems/physics',
    
    'systems/human',
    'systems/zombie',

    'systems/world',
    'systems/spawner',
    'systems/combat',

    'systems/userInterface',
    'systems/renderer',
    'systems/logger'

    ], (UserMovable,
    Flocking, Physics,
    Human, Zombie,
    World, Spawner, Combat, UserInterface,
    Renderer,
    Logger,
    )->
    class Systems
        constructor: (entities)->
            @entities = entities
            
            @systems =  [
                #Then check if a new entity is born
                new Spawner(@entities)
                
                #Check for user input
                new UserMovable(@entities)

                #Flocking (modifies physics)
                new Flocking(@entities)
                #Then update its position based on physics
                new Physics(@entities)
                
                #And then the grid / get its neighbors
                #TODO: Make sure position of this comes last-ish
                #  grid should get updated AFTER movement has happened
                new World(@entities)
                
                #Perform any fights
                new Combat(@entities)
                
                #------------------------
                #Check for living / dead state
                #   NOTE: This must happen after world and combat, as those
                #   systems set up various properites like getting neighbors
                #------------------------
                new Human(@entities)
                new Zombie(@entities)

                #Add a UI layer
                new UserInterface(@entities)

                #Finally render it
                new Renderer(@entities)
                
                #And do any logging
                new Logger(@entities)
            ]

            return @
    
    return Systems
)
