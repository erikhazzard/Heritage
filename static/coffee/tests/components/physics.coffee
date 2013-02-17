#========================================
#TEST - Component - Physics
#========================================
define(['components/vector', 'components/physics', 'entity'], (Vector, Physics, Entity)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Physics: Base tests', ()->
        it('Should setup physics component', ()->
            physics = new Physics()
        )
    )

    #--------------------------------
    #Physics force functions
    #--------------------------------
    describe('Physics: seek() tests', ()->
        it('should return a proper seek force', ()->
            a = new Entity()
                .addComponent('physics')
                .addComponent('position')
            b = new Entity()
                .addComponent('physics')
                .addComponent('position')
                
            #a seeking b, both with position of 0,0 should return 0,0
            force = a.components.physics.seekForce(b)
            force.x.should.equal(0)
            force.y.should.equal(0)
            
            a.components.position = new Vector(4,4)
            b.components.position = new Vector(8,8)
            a.components.physics.maxForce = 0.5
            a.components.physics.maxSpeed = 8
            #When the maxForce and speed are set to those values, we should get 
            #  this
            force = a.components.physics.seekForce(b)
            force.x.should.equal(0.35355339059327373)
            force.y.should.equal(0.35355339059327373)

        )
    )
    
    describe('Physics: applyForce()', ()->
        it('should return apply a force', ()->
            
        )
    )
)
