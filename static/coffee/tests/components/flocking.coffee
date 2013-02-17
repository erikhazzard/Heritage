#========================================
#TEST - Component - Flocking
#========================================
define(['components/vector', 'components/flocking', 'entities', 'entity'], (
    Vector, Flocking, Entities, Entity)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Flocking: main flock() tests', ()->
        it('should update position after calling flock()', ()->
            entities = new Entities()
            a = new Entity()
            a.addComponent('position')
            a.addComponent('physics')
            a.addComponent('flocking')
            a.components.position.x = 4
            a.components.position.y = 4

            b = new Entity()
            b.addComponent('position')
            b.addComponent('physics')
            b.addComponent('flocking')
            b.components.position.x = 10
            b.components.position.y = 10
            
            #add entities
            entities.add(a)
            entities.add(b)
            
            #try to flock
            a.components.flocking.flock(entities.entitiesIndex.flocking)
            #Position should not be the same
            a.components.position.x.should.equal(4)
            a.components.position.y.should.equal(4)
        )
    )
    
    #--------------------------------
    #Separate
    #--------------------------------
    describe('Flocking: separate() tests', ()->
        #TODO: test with params, make sure values are correct
        it('should define proper separate() behavior', ()->
            entities = new Entities()
            a = new Entity()
            a.addComponent('position')
            a.addComponent('physics')
            a.addComponent('flocking')
            a.components.position.x = 4
            a.components.position.y = 4

            b = new Entity()
            b.addComponent('position')
            b.addComponent('physics')
            b.addComponent('flocking')
            b.components.position.x = 10
            b.components.position.y = 10
            
            entities.add(a).add(b)
            force = a.components.flocking.separate(entities.entitiesIndex.flocking)
            force.x.should.not.equal(undefined)
            force.y.should.not.equal(undefined)
        )
    )
)
