#============================================================================
#
#Vector Class - Definition for Vector class
#   2D vector
#
#============================================================================
define([], ()->
    class Vector
        constructor: (x,y)->
            @x = x || 0
            @y = y || 0
        
        copy: ()->
            #returns a copy of the passed in vector
            return new Vector( @x, @y )
        
        #--------------------------------
        #OPERATIONS
        #--------------------------------
        add: (vector, vector2)->
            #If one vector passed in, add to @ instance vector
            if not vector2
                if typeof(vector) != 'number'
                    #It's a vector
                    @x += vector.x
                    @y += vector.y
                else
                    #If a scalar was passed in, add it
                    @x += vector
                    @y += vector
                    
                returnVector = @
            else
                #Two vectors were passed in, so return a new vector
                if typeof(vector2) != 'number'
                    #If they pass in two vectors
                    returnVector = new Vector(
                        vector.x + vector2.x,
                        vector.y + vector2.y
                    )
                else
                    #If they pass in a vector and a scalar
                    returnVector = new Vector(
                        vector.x + vector2
                        vector.y + vector2
                    )
                    
            #Return the vector object
            return returnVector
            
        subtract: (vector, vector2)->
            #Same interface as add, but subtracts
            
            if not vector2
                if typeof(vector) != 'number'
                    #It's a vector
                    @x -= vector.x
                    @y -= vector.y
                else
                    #If a scalar was passed in, add it
                    @x -= vector
                    @y -= vector
                    
                returnVector = @
            else
                if typeof(vector2) != 'number'
                    #If they pass in two vectors
                    returnVector = new Vector(
                        vector.x - vector2.x,
                        vector.y - vector2.y
                    )
                else
                    #If they pass in a vector and a scalar
                    returnVector = new Vector(
                        vector.x - vector2
                        vector.y - vector2
                    )
                    
            return returnVector
        
        multiply: (scalar)->
            @x *= scalar
            @y *= scalar
            return @
        
        divide: (scalar)->
            if scalar != 0
                @x /= scalar
            if scalar != 0
                @y /= scalar
                
            return @
        
        #--------------------------------
        #Calculation functions
        #--------------------------------
        magnitude: ()->
            return Math.sqrt( (@x * @x) + (@y * @y) )
        
        magnitudeSquared: ()->
            return (@x * @x) + (@y * @y)
        
        limit: (max)->
            #Limit the magnitude of a vector
            magnitude = @magnitude()
            if Math.abs(magnitude) > max
                #normalize
                @divide(magnitude)
                #multiply
                @multiply(max)
            return @
        
        normalize: ()->
            magnitude = @magnitude()
            
            if magnitude != 0
                @divide(magnitude)
                
            return @
        
        dotProduct: (vector1, vector2)->
            #Can pass in either one or two vectors. If one vector is passed,
            #  assume we multiply it by ourself
            #  Same interface as add and subtract
            if not vector2
                dot = (@x * vector1.x) + (@y * vector1.y)
            else
                #two vectors passed in
                dot = (vector1.x * vector2.x) + (vector1.y * vector2.y)

            return dot

        angle: (vector1, vector2)->
            #Can pass in a single vector and compare it with this vector,
            #   or two vectors
            if not vector2
                #use vector 1 and 2, set vector2 to vector1
                vector2 = vector1
                vector1 = @

            #Find angle between two vectors
            dot = vector1.dotProduct(vector1, vector2)
            
            angle = Math.acos(
                dot / ( vector1.magnitude() * vector2.magnitude())
            )
            #convert to degrees
            angle = angle * (180 / Math.PI)
            if not angle
                angle = 0

            return angle

        distance: (vector1, vector2)->
            #same interface as angle, can pass in two vectors
            if not vector2
                #use vector 1 and 2, set vector2 to vector1
                vector2 = vector1
                vector1 = @
                
            dist = Math.sqrt( \
                Math.pow((vector1.x - vector2.x), 2) \
                + Math.pow((vector1.y - vector2.y) , 2))
            
            return dist

    return Vector
)
