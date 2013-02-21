#========================================
#TEST - System - Human
#========================================
define(['systems/human', 'assemblages/assemblages', 'entity', 'entities'], (
    Human, Assemblages, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Human System: Base tests', ()->
        it('Should setup human system', ()->
            human = new Human()
        )
    )
    
    #------------------------------------
    #Update resources
    #------------------------------------
    describe('Human System: Resources tests', ()->
        it('Should update health and whatnot based on resources', ()->
            human = new Human()
            entities = new Entities()
            #add some entities
            entities.add(Assemblages.human())
                .add( Assemblages.human())
            console.log(entities)
            
        )
    )
)
