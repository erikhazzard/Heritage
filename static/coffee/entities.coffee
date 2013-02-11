#===========================================================================
#
#Entities - Collection of Entities
#
#===========================================================================
define([], ()->
    class Entities
        constructor: (params)->
            @entities = []

        add: (params)->
            params = params or {}
            @entities.push(new Entity(params))
            
        remove: (i)->
            @entities.splice(i,1)

        applyForce: (force)->
            for entity in @entities
                @entities[entity].applyForce(force)
                
    return Entities
)
