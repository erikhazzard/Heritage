#============================================================================
#
#Components - returns object containing all components
#
#============================================================================
define(['components/position',
    'components/world',
    'components/renderer',
    'components/physics',
    'components/randomWalker',
    'components/flocking',
    ], (
    Position, World, Renderer, Physics, RandomWalker, Flocking
    )->
    Components = {
        renderer: Renderer
        
        #World related
        world: World
        position: Position
        physics: Physics
        
        randomWalker: RandomWalker
        flocking: Flocking
    }
    return Components
)
