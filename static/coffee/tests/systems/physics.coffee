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

    #--------------------------------
    #tick update
    #--------------------------------
    describe('Physics System: tick() update tests', ()->
        it('tick() should properly update position', ()->
            #setup entity
            entity = new Entity()
            entities = new Entities()
            entities.add(entity)
            entity.addComponent('world')
            entity.addComponent('physics')
            entity.addComponent('position')
            physicsComponent = entity.components.physics
            physicsSystem = new PhysicsSystem(entities)
            
            #Start position should be 0
            entity.components.position.x.should.equal(0)
            entity.components.position.y.should.equal(0)
            
            #When we run tick, it should update position based on
            #  physics velocity and acceleration (which is 0 now)
            physicsSystem.tick()
            entity.components.position.x.should.equal(0)
            entity.components.position.y.should.equal(0)
            #After changing velocity, should affect position
            physicsComponent.velocity = new Vector(2,2)
            physicsSystem.tick()
            entity.components.position.x.should.equal(2)
            entity.components.position.y.should.equal(2)
        )
        it('tick() should properly update velocity and acceleration', ()->
            entity = new Entity()
            entities = new Entities()
            entities.add(entity)
            entity.addComponent('physics')
            entity.addComponent('position')
            
            physicsComponent = entity.components.physics
            physicsComponent.velocity = new Vector(2,2)
            
            physicsSystem = new PhysicsSystem(entities)
            physicsSystem.tick()
            entity.components.position.x.should.equal(2)
            entity.components.position.y.should.equal(2)
            
            #Now with acceleration
            physicsComponent.acceleration = new Vector(1,1)
            
            physicsSystem.tick()
            entity.components.position.x.should.equal(5)
            entity.components.position.y.should.equal(5)
            #acceleration should reset to 0
            entity.components.physics.acceleration.x.should.equal(0)
            entity.components.physics.acceleration.y.should.equal(0)
            #and velocity should be 3,3 (old velocity + acceleration)
            entity.components.physics.velocity.x.should.equal(3)
            entity.components.physics.velocity.y.should.equal(3)

            #check again now
            physicsSystem.tick()
            entity.components.position.x.should.equal(8)
            entity.components.position.y.should.equal(8)
        )
    )

)
