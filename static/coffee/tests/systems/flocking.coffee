#========================================
#TEST - Component - Flocking
#========================================
define(['components/vector', 'systems/flocking', 'systems/world', 'entities', 'entity'], (
    Vector, Flocking, World, Entities, Entity)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Flocking System', ()->
        describe('flock() function', ()->
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

                flocking = new Flocking(entities)
                
                #try to flock
                flocking.flock(a, entities.entitiesIndex.flocking)
                #Position should not be the same
                a.components.position.x.should.equal(4)
                a.components.position.y.should.equal(4)
            )
        )
        
        #--------------------------------
        #
        #Cohesion / Separate / Align - basic
        #
        #--------------------------------
        describe('Flocking sub functions  - two entities', ()->
            #TODO: test with params, make sure values are correct
            entities = new Entities()
            a = new Entity()
            a.addComponent('position')
            a.addComponent('physics')
            a.addComponent('flocking')
            a.addComponent('world')
            a.addComponent('human')
            a.components.position.x = 4
            a.components.position.y = 4
            a.components.physics.velocity.x = 2
            a.components.physics.velocity.y = 4

            b = new Entity()
            b.addComponent('position')
            b.addComponent('physics')
            b.addComponent('flocking')
            b.addComponent('world')
            b.addComponent('human')
            b.components.position.x = 10
            b.components.position.y = 10
            b.components.physics.velocity.x = 4
            b.components.physics.velocity.y = 8
            
            entities.add(a)
                .add(b)

            flocking = new Flocking(entities)

            describe('separate()', ()->
                it('separate should return proper values', ()->
                    force = flocking.separate(a, entities.entitiesIndex.flocking)
                    force.x.should.equal(-4.970348660325108)
                    force.y.should.equal(-6.268622990322866)
                )

                it('should return same values when neighbors from a grid are passed in', ()->

                    #Must call world tick to setup grid
                    world = new World(entities)
                    world.tick()
                    console.log('about to call')
                    force = flocking.separate(
                        a,
                        a.components.world.getNeighbors(20)
                    )
                    force.x.should.equal(-4.970348660325108)
                    force.y.should.equal(-6.268622990322866)
                )
            )
            describe('cohesion()', ()->
                it('cohesion should return proper values', ()->
                    force = flocking.cohesion(a,entities.entitiesIndex.flocking)
                    force.x.should.equal(0.4996908008410636)
                    force.y.should.equal(0.017581341098348992)
                )
            )
            describe('align()', ()->
                it('align should return proper values', ()->
                    force = flocking.align(a, entities.entitiesIndex.flocking)
                    force.x.should.equal(0.22360679774997896)
                    force.y.should.equal(0.4472135954999579)
                )
            )
        )
        
        #--------------------------------
        #
        #Cohesion / Separate / Align - more entities
        #
        #--------------------------------
        describe('Flocking sub functions  - multiply entities', ()->
            #TODO: test with params, make sure values are correct
            entities = new Entities()
            a = new Entity()
                .addComponent('position')
                .addComponent('physics')
                .addComponent('flocking')
                .addComponent('human')
            a.components.position.x = 4
            a.components.position.y = 4
            a.components.physics.velocity.x = 2
            a.components.physics.velocity.y = 4

            b = new Entity()
                .addComponent('position')
                .addComponent('physics')
                .addComponent('flocking')
                .addComponent('human')
            b.components.position.x = 10
            b.components.position.y = 10
            b.components.physics.velocity.x = 1
            b.components.physics.velocity.y = 2

            c = new Entity()
                .addComponent('position')
                .addComponent('physics')
                .addComponent('flocking')
                .addComponent('human')
            c.components.position.x = 6
            c.components.position.y = 8
            
            d = new Entity()
                .addComponent('position')
                .addComponent('physics')
                .addComponent('flocking')
                .addComponent('human')
            d.components.position.x = 2
            d.components.position.y = 2

            #This should NOT affect results
            e = new Entity()
                .addComponent('position')
                .addComponent('physics')
                .addComponent('flocking')
                .addComponent('human')
            e.components.position.x = 300
            e.components.position.y = 300
            e.components.physics.velocity.x = 4
            e.components.physics.velocity.y = 7

            #add entities
            entities.add(a)
                .add(b)
                .add(c)
                .add(d)

            flocking = new Flocking(entities)

            #----------------------------
            #TESTS
            #----------------------------
            describe('separate()', ()->
                it('separate should return proper values', ()->
                    force = flocking.separate(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(4.500017344982671)
                    force.y.should.equal(-6.614366477211186)
                )

                entities.add(e)
                it('adding far away entity should NOT modify values', ()->
                    force = flocking.separate(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(4.500017344982671)
                    force.y.should.equal(-6.614366477211186)
                )
                entities.remove(e)
            )
            describe('cohesion()', ()->
                it('cohesion should return proper values', ()->
                    force = flocking.cohesion(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(-0.2036416367602448)
                    force.y.should.equal(-0.45665094303812465)
                )
                entities.add(e)
                it('adding far away entity should NOT modify values', ()->
                    force = flocking.cohesion(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(-0.2036416367602448)
                    force.y.should.equal(-0.45665094303812465)
                )
                entities.remove(e)
            )
            describe('align()', ()->
                it('align should return proper values', ()->
                    force = flocking.align(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(0.22360679774997896)
                    force.y.should.equal(0.4472135954999579)
                )

                entities.add(e)
                it('adding far away entity should NOT modify values', ()->
                    force = flocking.align(
                        a, entities.entitiesIndex.flocking
                    )
                    force.x.should.equal(0.22360679774997896)
                    force.y.should.equal(0.4472135954999579)
                )
                entities.remove(e)
            )
        )
    )
)
