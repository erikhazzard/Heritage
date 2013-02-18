#============================================================================
#
#Systems - UserInput
#   Handles logic for user input
#
#============================================================================
define(['components/vector'], (Vector)->
    class UserInput
        constructor: (entities)->
            @entities = entities
            document.addEventListener('keydown', (e)=>
                force = new Vector(0,0)
                if e.keyCode == 37
                    force.add(new Vector(-1,0))
                else if e.keyCode == 38
                    force.add(new Vector(0,-1))
                else if e.keyCode == 39
                    force.add(new Vector(1,0))
                else if e.keyCode == 40
                    force.add(new Vector(0,1))
                    
                @inputForce = force.copy()
                    
            )
            @inputForce = null
            return @

        tick: (delta)->
            for id, entity of @entities.entitiesIndex.userMovable
                if entity.hasComponent('physics')
                    if @inputForce
                        entity.components.physics.applyForce(
                            @inputForce
                        ).multiply(2)
            

    return UserInput
)
