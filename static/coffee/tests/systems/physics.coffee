#========================================
#TEST - System - Physics
#========================================
define(['components/vector', 'components/physics',
    'systems/physics', 'entity', 'entities'], (
    Vector, PhysicsComponent, PhysicsSystem, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Physics System: Base tests', ()->
        it('Should setup physics component', ()->
            physics = new PhysicsSystem()
        )
    )

)
