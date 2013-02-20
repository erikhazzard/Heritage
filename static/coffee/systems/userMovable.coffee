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
            
            #Keep track of mouse
            #   Update mouse position
            @mouseVector = new Vector(0,0)
            document.getElementById('canvas').addEventListener('mousemove', (e)=>
                @mouseVector.x = e.offsetX
                @mouseVector.y = e.offsetY
                
            )
            #OLD: Keyboard
            #document.addEventListener('keydown', (e)=>
                #force = new Vector(0,0)
                #if e.keyCode == 37
                    #force.add(new Vector(-1,0))
                #else if e.keyCode == 38
                    #force.add(new Vector(0,-1))
                #else if e.keyCode == 39
                    #force.add(new Vector(1,0))
                #else if e.keyCode == 40
                    #force.add(new Vector(0,1))
                    
                #@inputForce = force.copy()
                    
            #)
            return @

        tick: (delta)->
            for id, entity of @entities.entitiesIndex.userMovable
                if entity.hasComponent('physics')
                    physics = entity.components.physics
                    
                    #OLD: keyboard
                    #entity.components.physics.applyForce(
                        #@inputForce
                    #).multiply(2)
                    
                    #Follow mouse
                    physics.applyForce(
                        @mouseVector.copy().subtract(entity.components.position)
                    )
            

    return UserMovable
)
