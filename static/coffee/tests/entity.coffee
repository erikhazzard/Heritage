#========================================
#TEST - Model - World
#========================================
define(['entity', 'components/vector', 'world'], (Entity, Vector, world)->
    
    describe('Entity: Setup', ()->
        it('should successfully create a new entity', ()->
            entity = new Entity()
            entity2 = new Entity()
            entity.should.not.equal(undefined)
            
            #Make sure draw function is using prototype
            entity.draw.should.equal(entity2.draw)
        )

        it('should successfully create a new entity with some properties', ()->
            entity = new Entity()
            #Movement properties
            entity.position.should.not.equal(undefined)
            entity.velocity.should.not.equal(undefined)
            entity.acceleration.should.not.equal(undefined)
            entity.maxForce.should.not.equal(undefined)
            entity.maxSpeed.should.not.equal(undefined)
            
            #Other properties
            entity.health.should.not.equal(undefined)
            entity.food.should.not.equal(undefined)
        )
    )

    #------------------------------------
    #Check edges
    #------------------------------------
    describe('Entity: checkEdges', ()->
        it('should wrap around edges', ()->
            entity = new Entity({
                position: new Vector(0,0)
                positionMax: new Vector(30,30)
            })
            entity.checkEdges()
            
            #Position should remain the same
            entity.position.x.should.equal(0)
            entity.position.y.should.equal(0)
            
            #Should wrap to width
            entity.position = new Vector(31,31)
            entity.checkEdges()
            #Position should remain the same
            entity.position.x.should.equal(1)
            entity.position.y.should.equal(1)
            
            #Should wrap to width
            entity.position = new Vector(30,30)
            entity.checkEdges()
            #Position should remain the same
            entity.position.x.should.equal(0)
            entity.position.y.should.equal(0)

            #Should wrap to width
            entity.position = new Vector(-1,-1)
            entity.checkEdges()
            #Position should remain the same
            entity.position.x.should.equal(29)
            entity.position.y.should.equal(29)
            entity.updatePositionGrid()
            #Position should remain the same
            entity.positionGrid.i.should.equal(2)
            entity.positionGrid.j.should.equal(2)
        )
    )
)
