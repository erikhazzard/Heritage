#============================================================================
#
#Systems - All
#   Loads all the systems and returns an object containing all system names
#   and systems
#
#============================================================================
define(['systems/renderer'], (Renderer)->
    Systems = {
        'renderer': Renderer
    }
    
    return Systems
)
