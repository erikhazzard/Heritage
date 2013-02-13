#========================================
#TEST - Component - Position
#========================================
define(['components/vector', 'components/position'], (Vector, Position)->
    #NOTE: Position extends the vector component
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Position: Base tests', ()->
        it('should successfully create a new position component', ()->
            position = new Position()
            position.x.should.not.equal(undefined)
            position.y.should.not.equal(undefined)
            position.add.should.not.equal(undefined)
            position.subtract.should.not.equal(undefined)
        )
        it('should create position with starting params', ()->
            position = new Position(null, {x: 5, y: 5})
        )
        it('should extend vector component', ()->
            position1 = new Position()
            position2 = new Position()
            position1.should.not.equal(position2)
            position1.add.should.equal(position2.add)
            
            #make sure it's the same object
            sameObj = position1.add is position2.add
            sameObj.should.be.true
        )
    )
)
