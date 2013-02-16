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
define(['systems/renderer',
    'systems/physics',
    'systems/living',
    'systems/world',
    'systems/spawner',
    ], (Renderer, Physics, Living, World, Spawner)->
    class Systems
        constructor: (entities)->
            @entities = entities
            
            @systems =  [
                #First, check if entity is alive
                new Living(@entities)

                #Then check if a new entity is born
                new Spawner(@entities)

                #Then update its position based on physics
                new Physics(@entities)
                
                #And then the grid / get its neighbors
                new World(@entities)
                
                #Finally render it
                new Renderer(@entities)
            ]

            return @
    
    return Systems
)
