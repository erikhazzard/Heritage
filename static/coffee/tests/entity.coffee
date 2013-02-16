#========================================
#TEST - Entity
#========================================
define(['entity'], (Entity)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Entity: Base Tests', ()->
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
        it('should add an array of component', ()->
            a = new Entity()
            a.addComponents(['renderer', 'position'])
            a.hasComponent('renderer').should.be.true
            a.hasComponent('position').should.be.true
            a.getComponentNames().should.deep.equal(['renderer', 'position'])
        )
        it('should remove a component', ()->
            a = new Entity()
            a.addComponent('renderer')
            a.removeComponent('renderer')
            a.components.should.deep.equal({})
        )
        it('should return proper values for hasComponent()', ()->
            a = new Entity()
            a.addComponent('renderer')
            a.hasComponent('renderer').should.be.true
        )
        it('should list of components', ()->
            a = new Entity()
            a.addComponent('renderer')
            a.addComponent('position')
            
            a.getComponentNames().should.deep.equal(['renderer', 'position'])
        )
    )
)
