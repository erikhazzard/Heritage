#============================================================================
#
#Systems - UserMovable
#   Handles logic for user input
#
#============================================================================
define(['components/vector'], (Vector)->
    class UserMovable
        
        constructor: (entities)->
            #Note: systems are constructed only once
            @entities = entities
            
            #keep track of keys pressed - allows multiple keys to be pressed
            #  for diagonal movement
            @keysPressed = {
                #left
                '37': false
                #up
                '38': false
                #right
                '39': false
                #down
                '40': false
            }
            
            @inputForce = new Vector(0,0)
            
            #Keyboard Input
            document.addEventListener('keydown', (e)=>
                #keep track of key pressed
                key = e.keyCode
                if(key > 36 && key < 41)
                    @keysPressed[key] = true
                    
                return true
            )
            
            document.addEventListener('keyup', (e)=>
                #when keyup is pressed, reset 
                key = e.keyCode
                if(key > 36 && key < 41)
                    @keysPressed[key] = false
                
                return true
            )
            return @

        tick: (delta)->
            for id, entity of @entities.entitiesIndex.userMovable
                if entity.hasComponent('physics')
                    physics = entity.components.physics
                    
                    #Reset input force
                    @inputForce.x = 0
                    @inputForce.y = 0
                    
                    #Get the direction(s) the user wants to move
                    if @keysPressed['37'] == true
                        @inputForce.x -= 1
                    if @keysPressed['38'] == true
                        @inputForce.y -= 1
                    if @keysPressed['39'] == true
                        @inputForce.x += 1
                    if @keysPressed['40'] == true
                        @inputForce.y += 1
                        
                    #keyboard
                    physics.applyForce(
                        @inputForce.multiply(2)
                    )
                    
                    #Set velocity to 0 if inputForce is 0
                    if @inputForce.x == 0 and @inputForce.y == 0
                        physics.velocity.multiply(0)
                        
            return true

    return UserMovable
)
