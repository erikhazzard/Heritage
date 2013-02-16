#========================================
#TEST - Component - World
#========================================
define(['components/world'], (World)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('World: Base tests', ()->
        it('Should setup world component and properties', ()->
            world = new World()
            world.should.not.equal(undefined)
            world.width.should.not.equal(undefined)
            world.height.should.not.equal(undefined)
            world.canvas.should.not.equal(undefined)
            world.context.should.not.equal(undefined)
            
            world2 = new World()
            world.should.not.equal(undefined)
        )
        it('Should use prototype for default props', ()->
            world = new World()
            world2 = new World()
            
            contextIdentical = world.context is world2.context
            contextIdentical.should.be.true
            contextIsPrototype = world.context is World.context
            contextIsPrototype.should.be.true
        )
    )
)
