#========================================
#TEST - Entity
#========================================
define(['entity'], (Entity)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Entity: Setup', ()->
        it('should successfully create an entity', ()->
            a = new Entity()
            a.components.should.deep.equal({})
        )
        it('should add a component', ()->
            a = new Entity()
            a.addComponent('renderer')
            a.components.renderer.should.not.equal(undefined)
            a.hasComponent('renderer').should.be.true
        )
        it('should remove a component', ()->
            a = new Entity()
            a.addComponent('renderer')
            a.removeComponent('renderer')
            a.components.should.deep.equal({})
        )
    )
)
