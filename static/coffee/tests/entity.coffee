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
            a.addComponent('vector')
            a.components.vector.should.not.equal(undefined)
            a.hasComponent('vector').should.be.true
        )
        it('should remove a component', ()->
            a = new Entity()
            a.addComponent('vector')
            a.removeComponent('vector')
            a.components.should.deep.equal({})
        )
    )
)
