#============================================================================
#
#Systems - Living (Think of better name?)
#   Handles logic to keep an entity 'alive'
#
#============================================================================
define([], ()->
    class Living
        constructor: (entities)->
            @entities = entities
            return @
        
        tick: (delta)->
            #Go through all creatures (note: humans, zombies, etc. all have
            #  a creature component)
            for id, entity of @entities.entitiesIndex['human']
                #Call tick(). Note that any 'sub components' like human or
                #  zombie will have extended tick(), so we're also accessing
                #  those behaviors as well
                entity.components.human.tick()
                
                #If the entity is dead, remove it
                if entity.components.human.isDead
                    @entities.remove(entity)
    
    return Living
)
