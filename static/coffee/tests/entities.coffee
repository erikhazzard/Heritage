#========================================
#TEST - Entities
#========================================
define(['entities', 'entity'], (Entities, Entity)->
    
    describe('Entities: Setup', ()->
        #--------------------------------
        #SETUP
        #--------------------------------
        it('should setup Entities', ()->
            entities = new Entities()
            entities.should.not.equal(undefined)
            entities._currentId.should.equal(0)
        )
        
        #--------------------------------
        #Add / remove entities
        #--------------------------------
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

        #--------------------------------
        #Component related
        #--------------------------------
        it('should get update index when component is added', ()->
            entities = new Entities()
            #Add entity
            entity = new Entity()
            entities.add(entity)
            entities.entitiesIndex.should.deep.equal({})
            
            entity.addComponent('renderer')
            entity.hasComponent('renderer').should.be.true
            entitiesByComponent = entities._getEntities('renderer')
            #should return id: entity, where entity has the component
            entitiesByComponent.should.deep.equal({
                '0': entity
            })
            
            #make sure index gets updated
            entities.entitiesIndex.should.deep.equal({
                renderer: {'0': entity}
            })
        )
        
        it('should return entities with components when entity is created then added', ()->
            #Create an entity, add a component to it, then add it
            #   to a newly created Entities object.  When it gets added
            #   it should automatically update the entitiesIndex object
            entity = new Entity()
            entity.addComponent('renderer')
            
            entities = new Entities()
            entities.entitiesIndex.should.deep.equal({})
            entities.add(entity)
            entities.entities.should.deep.equal({ '0': entity })
            entities.entitiesIndex.should.deep.equal({
                'renderer': {'0': entity}
            })
        )
        
        it('should update index when component is removed from entity', ()->
            entities = new Entities()
            #Add entity
            entity = new Entity()
            entities.add(entity)
            entity.addComponent('renderer')
            entity.hasComponent('renderer').should.be.true
            #Remove component
            entity.removeComponent('renderer')
            entity.hasComponent('renderer').should.be.false

            #make sure index gets updated
            entities.entitiesIndex.should.deep.equal({
                renderer: {}
            })
        )
    )
)
