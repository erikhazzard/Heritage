#========================================
#TEST - System - spawner
#========================================
define(['systems/spawner', 'entity', 'entities', 'assemblages/assemblages'], (
    Spawner, Entity, Entities, Assemblages)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Spawner System', ()->
        entityMale = Assemblages.human()
        entityFemale = Assemblages.human()
            
        #make them next to each other
        entityMale.components.position.x = 10
        entityMale.components.position.y = 10
        
        entityFemale.components.position.x = 10
        entityFemale.components.position.y = 11
        
        entities = new Entities()
            .add(entityMale)
            .add(entityFemale)
        spawner = new Spawner(entities)
            
        it('should find mate', ()->
            consolespawner.findMate(entityMale, [entityMale.id])

        )
    )
)
