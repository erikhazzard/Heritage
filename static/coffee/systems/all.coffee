#============================================================================
#
#Systems - All
#   Loads all the systems and returns an object containing all system names
#   and systems
#
#============================================================================
define(['systems/renderer'], (Renderer)->
    class Systems
        constructor: (entities)->
            @entities = entities
            
            @systems =  {
                'renderer': new Renderer(@entities)
            }

            return @
    
    return Systems
)
