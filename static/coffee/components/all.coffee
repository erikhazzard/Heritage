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

    #Creature related
    'components/spawner',
    'components/creature',
    'components/human',
    'components/zombie',
    ], (
    Position, World, Renderer, Physics, RandomWalker, Flocking,
    Spawner, Creature, Human, Zombie
    )->
    Components = {
        renderer: Renderer
        
        #World related
        world: World
        position: Position
        
        physics: Physics
        randomWalker: RandomWalker
        flocking: Flocking
        
        #Creature related
        spawner: Spawner
        creature: Creature
        human: Human
        zombie: Zombie
    }
    return Components
)
