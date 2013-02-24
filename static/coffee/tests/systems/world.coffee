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
        
        entityZombie.components.position.x = 10
        entityZombie.components.position.y = 20

        entityZombie2.components.position.x = 40
        entityZombie2.components.position.y = 40

        #Must call world tick to setup grid
        world = new WorldSystem(entities)
        #call tick to update grid
        world.tick()
        
        it('Should setup world component and properties', ()->
        )
        it('Should use prototype for default props', ()->
        )
    )
)
