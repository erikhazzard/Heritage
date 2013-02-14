#========================================
#TEST - component - randomWalker
#========================================
define(['entity', 'components/vector', 'components/randomWalker'], (Entity, Vector, RandomWalker)->
    #NOTE: Position extends the vector component
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('RandomWalker: Walk tests', ()->
        it('should return some walk force', ()->
            entity = new Entity()
            entity.addComponent('physics')
            entity.addComponent('position')
            entity.addComponent('randomWalker')
            
            #This is a non deterministic function (we could use perlin noise), 
            #  so just make sure it returns a vector with x/y
            force = entity.components.randomWalker.walkForce()
            force.x.should.not.equal(undefined)
            force.x.should.not.equal(null)
            force.y.should.not.equal(undefined)
            force.y.should.not.equal(null)
        )
        it('should not affect entity position', ()->
            entity = new Entity()
            entity.addComponent('physics')
            entity.addComponent('position')
            entity.addComponent('randomWalker')
            entity.components.position = new Vector(4,4)
            entity.components.position.x.should.equal(4)
            entity.components.position.y.should.equal(4)
            #create force
            force = entity.components.randomWalker.walkForce()
            #make sure it doesn't change entity position 
            entity.components.position.x.should.equal(4)
            entity.components.position.y.should.equal(4)
        )
    )
)
