#========================================
#TEST - Component - Vector
#========================================
define(['components/vector'], (Vector)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Vector: Base Functions', ()->
        it('should successfully create a new vector', ()->
            vector = new Vector()
            vector.x.should.not.equal(undefined)
            vector.y.should.not.equal(undefined)
        )
        it('should copy successfully', ()->
            vector = new Vector(10,10)
            vector.x.should.equal(10)
            vector.y.should.equal(10)
            
            #copy vector
            vector2 = vector.copy()
            vector2.should.not.be.vector
            vector2.should.not.equal(vector)
            vector2.x.should.equal(10)
            vector2.y.should.equal(10)
            vector2.add(2)
            vector2.x.should.equal(12)
            vector2.y.should.equal(12)
            #ensure first vector is unchanged
            vector.x.should.equal(10)
            vector.y.should.equal(10)
        )
    )
    
    #--------------------------------
    #Addition
    #--------------------------------
    describe('Vector: Addition', ()->
        it('should add two vectors together (in place)', ()->
            vector1 = new Vector(1,1)
            vector2 = new Vector(1,1)
            #Mofidy vector 1 in place and return the vector1 object
            vectorResult = vector1.add(vector2)
            vector1.x.should.equal( 2 )
            vector1.y.should.equal( 2 )
            vectorResult.should.equal(vector1)
            vectorResult.should.deep.equal(vector1)
            vectorResult.should.not.equal(vector2)
            
            #vector 2 shouldn't change
            vector2.x.should.equal( 1 )
            vector2.y.should.equal( 1 )
            
            #again
            vector1.add(vector2)
            vector1.x.should.equal( 3 )
            vector1.y.should.equal( 3 )
            #vector 2 shouldn't change
            vector2.x.should.equal( 1 )
            vector2.y.should.equal( 1 )
        )
        it('should add a scalar and a vector', ()->
            vector1 = new Vector(1,1)
            vectorResult = vector1.add(3)
            #should modify object in place and return it
            vectorResult.should.be.vector1
            vectorResult.should.deep.equal(vector1)
            vector1.x.should.equal(4)
            vector1.y.should.equal(4)
        )
        
        it('should add two vectors together (new vector)', ()->
            vector1 = new Vector(1,1)
            vector2 = new Vector(1,1)
            #Create a NEW vector from the two
            vectorResult = vector1.add(vector1, vector2)
            
            #make sure it's new
            vectorResult.should.not.equal(vector1)
            vectorResult.should.not.deep.equal(vector1)
            vectorResult.should.not.equal(vector2)
            vectorResult.should.not.deep.equal(vector2)

            #and it's valid
            vectorResult.x.should.equal(2)
            vectorResult.y.should.equal(2)

            #Using prototype
            vector4 = Vector.prototype.add(vector1,vector2)
            #make sure vector 1 and 2 are unchanged
            vector1.x.should.equal(1)
            vector1.y.should.equal(1)
            vector2.x.should.equal(1)
            vector2.y.should.equal(1)
            vector4.x.should.equal(2)
            vector4.y.should.equal(2)
        )
        
        it('should add a vector and scalar together (new vector)', ()->
            vector1 = new Vector(1,1)
            #Create a NEW vector from the two
            vectorResult = vector1.add(vector1, 5)
            
            #make sure it's new
            vectorResult.should.not.equal(vector1)
            vectorResult.should.not.deep.equal(vector1)

            #and it's valid
            vectorResult.x.should.equal(6)
            vectorResult.y.should.equal(6)

            #Using prototype
            vector2 = Vector.prototype.add(vector1,5)
            #make sure vector 1 and 2 are unchanged
            vector1.x.should.equal(1)
            vector1.y.should.equal(1)
            
            #test new vector
            vector2.x.should.equal(6)
            vector2.y.should.equal(6)
            
            vector2.should.not.equal(vector1)
            vector2.should.not.deep.equal(vector1)
            
        )
    )
    
    #--------------------------------
    #Subtraction
    #--------------------------------
    describe('Vector: Subtraction', ()->
        it('should subtract two vectors together (in place)', ()->
            vector1 = new Vector(1,1)
            vector2 = new Vector(1,1)
            #Mofidy vector 1 in place and return the vector1 object
            vectorResult = vector1.subtract(vector2)
            vector1.x.should.equal( 0 )
            vector1.y.should.equal( 0 )
            vectorResult.should.equal(vector1)
            vectorResult.should.deep.equal(vector1)
            vectorResult.should.not.equal(vector2)
            
            #vector 2 shouldn't change
            vector2.x.should.equal( 1 )
            vector2.y.should.equal( 1 )
            
            #again
            vector1.subtract(vector2)
            vector1.x.should.equal( -1 )
            vector1.y.should.equal( -1 )
            #vector 2 shouldn't change
            vector2.x.should.equal( 1 )
            vector2.y.should.equal( 1 )
        )
        it('should subtract a scalar and a vector', ()->
            vector1 = new Vector(7,7)
            vectorResult = vector1.subtract(3)
            #should modify object in place and return it
            vectorResult.should.be.vector1
            vectorResult.should.deep.equal(vector1)
            vector1.x.should.equal(4)
            vector1.y.should.equal(4)
        )
        
        it('should subtract two vectors together (new vector)', ()->
            vector1 = new Vector(1,1)
            vector2 = new Vector(1,1)
            #Create a NEW vector from the two
            vectorResult = vector1.subtract(vector1, vector2)
            
            #make sure it's new
            vectorResult.should.not.equal(vector1)
            vectorResult.should.not.deep.equal(vector1)
            vectorResult.should.not.equal(vector2)
            vectorResult.should.not.deep.equal(vector2)

            #and it's valid
            vectorResult.x.should.equal(0)
            vectorResult.y.should.equal(0)

            #Using prototype
            vector4 = Vector.prototype.subtract(vector1,vector2)
            #make sure vector 1 and 2 are unchanged
            vector1.x.should.equal(1)
            vector1.y.should.equal(1)
            vector2.x.should.equal(1)
            vector2.y.should.equal(1)
            
            vector4.x.should.equal(0)
            vector4.y.should.equal(0)
        )
        
        it('should subtract a vector and scalar together (new vector)', ()->
            vector1 = new Vector(11,11)
            #Create a NEW vector from the two
            vectorResult = vector1.subtract(vector1, 5)
            
            #make sure it's new
            vectorResult.should.not.equal(vector1)
            vectorResult.should.not.deep.equal(vector1)

            #and it's valid
            vectorResult.x.should.equal(6)
            vectorResult.y.should.equal(6)

            #Using prototype
            vector2 = Vector.prototype.subtract(vector1,5)
            #make sure vector 1 and 2 are unchanged
            vector1.x.should.equal(11)
            vector1.y.should.equal(11)
            
            #test new vector
            vector2.x.should.equal(6)
            vector2.y.should.equal(6)
            
            vector2.should.not.equal(vector1)
            vector2.should.not.deep.equal(vector1)
        )
    )
    
    #--------------------------------
    #Multiply / Divide
    #--------------------------------
    describe('Vector: Multiply / Divide', ()->
        it('should multiply properly', ()->
            vector1 = new Vector(1,1)
            vector1.multiply(4)
            vector1.x.should.equal(4)
            vector1.y.should.equal(4)
            vector1.multiply(2)
            vector1.x.should.equal(8)
            vector1.y.should.equal(8)
            vector1.multiply(0)
            vector1.x.should.equal(0)
            vector1.y.should.equal(0)
        )
        it('should divide properly', ()->
            vector1 = new Vector(4,4)
            vector1.divide(2)
            vector1.x.should.equal(2)
            vector1.y.should.equal(2)
            #divide  by 0 should return same values
            vector1.divide(0)
            vector1.x.should.equal(2)
            vector1.y.should.equal(2)
            vector1.divide(2)
            vector1.x.should.equal(1)
            vector1.y.should.equal(1)
            
            vector1.x = 0
            vector1.y = 0
            vector1.divide(2)
            vector1.x.should.equal(0)
            vector1.y.should.equal(0)
        )
    )
    
    #--------------------------------
    #Calculation functions
    #--------------------------------
    describe('Vector: Calucations', ()->
        it('should properly calculate magnitude', ()->
            vector = new Vector(4,4)
            mag = vector.magnitude().should.equal(5.656854249492381)
            vector = new Vector(0,0)
            mag = vector.magnitude().should.equal(0)
            vector = new Vector(1,1)
            mag = vector.magnitude().should.equal(1.4142135623730951)
        )
        it('should properly limit a vector', ()->
            vector = new Vector(4,4)
            vector.limit(2)
            vector.x.should.equal(1.414213562373095)
            vector.y.should.equal(1.414213562373095)
            
            vector = new Vector(20,40)
            vector.limit(4)
            vector.x.should.equal(1.7888543819998317)
            vector.y.should.equal(3.5777087639996634)
        )
        
        it('should normalize properly', ()->
            vector = new Vector(4,4)
            vector.normalize()
            vector.x.should.equal(0.7071067811865475)
            vector.y.should.equal(0.7071067811865475)
            #magnitude will be something like 0.9999999999
            Math.round(vector.magnitude()).should.equal(1)
        )
        it('should calculate angle properly', ()->
            vector1 = new Vector(2,4)
            vector2 = new Vector(5,6)
            vector1.angle(vector2).should.equal(13.240519915187184)
            vector1 = new Vector(0,0)
            vector2 = new Vector(5,6)
            vector1.angle(vector2).should.equal(0)
        )
    )
    
    #--------------------------------
    #Dot production
    #--------------------------------
    describe('Vector: Dot Product', ()->
        it('should calculate dot product properly', ()->
            vector1 = new Vector(2,4)
            vector2 = new Vector(5,7)
            dotProduct = vector1.dotProduct(vector2)
            dotProduct.should.equal(38)
            
            vector1 = new Vector(0,0)
            vector2 = new Vector(5,7)
            dotProduct = vector1.dotProduct(vector2)
            dotProduct.should.equal(0,0)
        )
    )
    
    #--------------------------------
    #Distance
    #--------------------------------
    describe('Vector: Distance', ()->
        it('should calculate distance', ()->
            vector1 = new Vector(4,4)
            vector2 = new Vector(8,8)
            dist = vector1.distance(vector2)
            dist.should.equal(5.656854249492381)
            
            vector1 = new Vector(0,0)
            vector2 = new Vector(2,2)
            dist = vector1.distance(vector2)
            dist.should.equal(2.8284271247461903)
        )
    )
)
