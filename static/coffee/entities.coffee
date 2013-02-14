#===========================================================================
#
#Entities - Collection of Entities
#
#===========================================================================
define(['events'], (events)->
    class Entities
        constructor: (params)->
            @entities = {}
            @_currentId = 0
            
            #Index of entities by component name
            #  updated whenever an entity is added or removed
            #  used in systems
            @entitiesIndex = { }
            
            #Listen for events, update entities when an entity changes
            events.on('entity:component:added', (data)=>
                @addToIndex(data.componentName, data.id)
            )
            events.on('entity:component:removed', (data)=>
                @removeFromIndex(data.componentName, data.id)
            )
            return @

        addToIndex: (componentName, entityId)->
            #Updates the entity index 
            if not @entitiesIndex[componentName]
                @entitiesIndex[componentName] = {}
            #Store the entity object
            #  TODO: store only the ID?
            if entityId != undefined and entityId != null
                #Make sure ID exists
                @entitiesIndex[componentName][entityId] = @entities[entityId]
            return @entitiesIndex
        
        removeFromIndex: (componentName, entityId)->
            if not @entitiesIndex[componentName]
                @entitiesIndex[componentName] = {}
                
            if entityId != undefined and entityId != null
                delete @entitiesIndex[componentName][entityId]
            
            return @entitiesIndex

        #--------------------------------
        #Entities - add / remove
        #--------------------------------
        add: (entity)->
            #Update our list of entities
            @entities[@_currentId] = entity
            #Update the entity's ID
            entity.id = @_currentId
            
            @_currentId += 1

            #Update indexes
            for name, component of entity.components
                @addToIndex(name, entity.id)
            
            return entity
            
        remove: (id)->
            if @entities[id] and @entities[id].remove
                @entities[id].remove()
                
            delete @entities[id]
            return @
        
        #--------------------------------
        #Entities - get by component name
        #--------------------------------
        _getEntities: (componentName)->
            #Get current list of entities by component name.
            #NOTE: This shouldn't need to be used, as you can
            #   access @entitiesIndex[componentName] for an up to
            #   date object
            entitiesByComponent = {}
            
            for id, entity of @entities
                if entity.hasComponent(componentName)
                    entitiesByComponent[id] = entity

            return entitiesByComponent

    return Entities
)
