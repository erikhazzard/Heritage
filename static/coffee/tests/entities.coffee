#========================================
#TEST - Entities
#========================================
define(['entities', 'entity'], (Entities, Entity)->
    
    describe('Entities: Setup', ()->
        it('should setup Entities', ()->
            entities = new Entities()
            entities.should.not.equal(undefined)
            entities._currentId.should.equal(0)
        )
        it('should add entity', ()->
            entities = new Entities()
            entities.should.not.equal(undefined)
            entities._currentId.should.equal(0)
            #Add entity
            entity = new Entity()
            entities.add(entity)
            entities.entities.should.deep.equal({'0': entity})
            entities._currentId.should.equal(1)
            
            #Another
            entity2 = new Entity()
            entities.add(entity2)
            entities.entities.should.deep.equal({'0': entity, '1': entity2})
            entities._currentId.should.equal(2)
        )
        
        it('should remove an entity', ()->
            entities = new Entities()
            #Add entity
            entity = new Entity()
            entities.add(entity)
            entities.remove('0')
            entities.entities.should.deep.equal({})
            entities._currentId.should.equal(1)
        )
    )

)
