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
    #Physics tests
    #--------------------------------
    describe('Physics: tick() update tests', ()->
        it('tick() should properly update position', ()->
            #setup entity
            entity = new Entity()
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
)
