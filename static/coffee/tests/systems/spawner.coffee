#========================================
#TEST - System - spawner
#========================================
define(['systems/spawner', 'entity', 'entities'], (Spawner, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Spawner: Base Tests', ()->
        it('should successfully create an entity', ()->
            a = new Entity()
            a.components.should.deep.equal({})
        )
    )
)
