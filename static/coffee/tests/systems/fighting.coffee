#========================================
#TEST - System - Fighting
#========================================
define(['systems/fighting', 'entity', 'entities'], (Fighting, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Fighting System: Base Tests', ()->
        it('should exist', ()->
            a = new Fightin()
        )
    )
)
