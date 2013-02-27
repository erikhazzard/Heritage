#========================================
#TEST - System - Zombie
#========================================
define(['systems/zombie', 'assemblages/assemblages', 'entity', 'entities'], (
    Zombie, Assemblages, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Zombie System', ()->
        it('Should setup zombie system', ()->
            zombie = new Zombie()
            zombie.tick.should.not.equal(undefined)
        )
        
        #------------------------------------
        #
        #Update resources
        #
        #------------------------------------
    )
)
