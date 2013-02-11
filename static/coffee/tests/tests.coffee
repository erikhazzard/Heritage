#========================================
#TEST - Model - World
#========================================
define(['entity'], (Entity)->
    
    describe('Entity: Should create', ()->
        it('should successfully create an entity', ()->
            a = new Entity()
        )
    )

)
