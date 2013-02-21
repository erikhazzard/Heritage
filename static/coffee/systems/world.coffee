#============================================================================
#
#Systems - World 
#   Handles logic for updating game grid
#   TODO: Change the way this works, it's sort of acting like
#   a singleton in a sense
#
#============================================================================
define(['components/world'], (WorldComponent)->
    class World
        constructor: (entities)->
            @entities = entities
            return @
        
        tick: (delta)->
            #Reset the world grid
            #TODO: This way restricts us to only one world object
            WorldComponent.grid = {}
        
            for id, entity of @entities.entitiesIndex['world']
                #Update the grid with this entity's position
                entity.components.world.tick()
                
                #If the entity is dead, remove it
                human = entity.components.human
                zombie = entity.components.zombie
                #TODO: do this better, maybe a "living" component?
                if (human and human.isDead) or (zombie and zombie.isDead)
                    @entities.remove(entity)
    
            #Get each entity's neighbors
            for id, entity of @entities.entitiesIndex['world']
                entity.components.world.getNeighbors()
                
            return @
            
    return World
)
