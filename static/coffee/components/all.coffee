#============================================================================
#
#Components - returns object containing all components
#
#============================================================================
define(['components/position',
    'components/renderer',
    'components/physics',
    'components/randomWalker',
    'components/flocking',
    ], (
    Position, Renderer, Physics, RandomWalker, Flocking
    )->
    Components = {
        renderer: Renderer
        
        #World related
        position: Position
        physics: Physics
        
        randomWalker: RandomWalker
        flocking: Flocking
    }
    return Components
)
