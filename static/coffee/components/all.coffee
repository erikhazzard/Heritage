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


    'components/userMovable',

    #Creature related
    'components/health',
    'components/combat',
    'components/human',
    'components/zombie',
    ], (
    Position, World, Renderer, Physics, RandomWalker, Flocking,
    UserMovable,
    Health, Combat,
    Human, Zombie
    )->
    Components = {
        renderer: Renderer
        
        #World related
        world: World
        position: Position
        
        physics: Physics
        randomWalker: RandomWalker
        flocking: Flocking
        
        userMovable: UserMovable
        
        #Creature related
        health: Health
        combat: Combat
        human: Human
        zombie: Zombie
    }
    return Components
)
