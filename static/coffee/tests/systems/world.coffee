#========================================
#TEST - System - World
#========================================
define(['systems/world', 'components/world',
    'entity', 'entities', 'assemblages/assemblages'], (
    WorldSystem, WorldComponent, Entity, Entities, Assemblages)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('World System', ()->
        entityHuman = Assemblages.human()
        entityZombie = Assemblages.zombie()
        entityZombie2 = Assemblages.zombie()
        entities = new Entities()
            .add(entityHuman)
            .add(entityZombie)
            .add(entityZombie2)
            
        entityHuman.components.position.x = 10
        entityHuman.components.position.y = 10
        
        entityZombie.components.position.x = 12
        entityZombie.components.position.y = 12

        entityZombie2.components.position.x = 40
        entityZombie2.components.position.y = 40

        #Must call world tick to setup grid
        world = new WorldSystem(entities)
        #call tick to update grid
        world.tick()
        WorldComponent.cellSize = 4
        humanWorld = entityHuman.components.world
        
        describe('getNeighbors tests', ()->
            it('when radius is 0, should only get neighbors which occupy same cell', ()->
                #If cell size is 1, there are no entities which occupy same cell
                WorldComponent.cellSize = 1
                world.tick()
                humanWorld.getNeighbors(0).should.deep.equal([])
                humanWorld.neighborsByRadius[0].should.deep.equal([])
            )

            it('should get a single neighbor when radius is 1', ()->
                WorldComponent.cellSize = 2
                world.tick()
                humanWorld.getNeighbors(1).should.deep.equal([entityZombie.id])
                humanWorld.neighborsByRadius[1].should.deep.equal([entityZombie.id])
            )

            it('should get all neighbors when radius is big enough', ()->
                WorldComponent.cellSize = 10
                world.tick()
                neighbors = [entityZombie.id, entityZombie2.id]

                humanWorld.getNeighbors(3).should.deep.equal(neighbors)
                humanWorld.neighborsByRadius[3].should.deep.equal(neighbors)

                humanWorld.getNeighbors(2).should.deep.equal([entityZombie.id])
                humanWorld.neighborsByRadius[2].should.deep.equal([entityZombie.id])
            )

            it('should not return duplicate IDs when radius is huge', ()->
                #This should get ALL neighbors
                #NOTE: this kind of call should never happen
                WorldComponent.cellSize = 1000
                world.tick()
                neighbors = [entityZombie.id, entityZombie2.id]

                humanWorld.getNeighbors(30).should.deep.equal(neighbors)
                humanWorld.neighborsByRadius[30].should.deep.equal(neighbors)
            )

        )
    )
)
