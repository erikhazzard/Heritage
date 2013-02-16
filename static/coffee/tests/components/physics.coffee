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
    #tick update
    #--------------------------------
    describe('Physics: tick() update tests', ()->
        it('tick() should properly update position', ()->
            #setup entity
            entity = new Entity()
            entity.addComponent('world')
            entity.addComponent('physics')
            entity.addComponent('position')
            physics = entity.components.physics
            
            #Start position should be 0
            entity.components.position.x.should.equal(0)
            entity.components.position.y.should.equal(0)
            
            #When we run tick, it should update position based on
            #  physics velocity and acceleration (which is 0 now)
            physics.tick()
            entity.components.position.x.should.equal(0)
            entity.components.position.y.should.equal(0)
            #After changing velocity, should affect position
            physics.velocity = new Vector(2,2)
            physics.tick()
            entity.components.position.x.should.equal(2)
            entity.components.position.y.should.equal(2)
        )
        it('tick() should properly update velocity and acceleration', ()->
            entity = new Entity()
            entity.addComponent('physics')
            entity.addComponent('position')
            physics = entity.components.physics
            physics.velocity = new Vector(2,2)
            physics.tick()
            entity.components.position.x.should.equal(2)
            entity.components.position.y.should.equal(2)
            
            #Now with acceleration
            physics.acceleration = new Vector(1,1)
            
            physics.tick()
            entity.components.position.x.should.equal(5)
            entity.components.position.y.should.equal(5)
            #acceleration should reset to 0
            entity.components.physics.acceleration.x.should.equal(0)
            entity.components.physics.acceleration.y.should.equal(0)
            #and velocity should be 3,3 (old velocity + acceleration)
            entity.components.physics.velocity.x.should.equal(3)
            entity.components.physics.velocity.y.should.equal(3)

            #check again now
            physics.tick()
            entity.components.position.x.should.equal(8)
            entity.components.position.y.should.equal(8)
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
