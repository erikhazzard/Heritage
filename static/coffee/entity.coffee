#============================================================================
#
#Entity Class - Definition for Entity
#
#============================================================================
define(['components/all','events'], (Components, events)->
    class Entity
        constructor: (params)->
            #id is automatically set when added to the Entities list
            #   (when entities.add(entity) is called
            @id = null
            #The components are what 'defines' the entity
            @components = {}

            return @
        
        remove: ()->
            for name, component of @components
                if component and component.remove
                    component.remove
            return @
        
        #--------------------------------
        #
        #Components
        #
        #--------------------------------
        addComponent: (name)->
            #Create component, pass in this entity object
            #   NOTE: Interface for components always assume an entity is 
            #   passed in as first parameter
            @components[name] = new Components[name](@)
            events.trigger('entity:component:added', {
                id: @id,
                componentName: name
            })
            return @
        addComponents: (names)->
            #Expects an array of component names and adds each one
            for name in names
                @addComponent(name)
                
            return @
        
        removeComponent: (name)->
            #Try to call destroy function if it exists
            if @components[name] && @components[name].destroy
                @components[name].destroy()
                
            #Remove from components object
            delete @components[name]
            
            #trigger event, entities will be notified of component removal
            events.trigger('entity:component:removed', {
                id: @id,
                componentName: name
            })

            return @
        
        hasComponent: (name)->
            #Takes in a component name {String} and returns either
            #  true or false if the entity has the component
            if @components[name]
                return true
            else
                return false
            
        getComponentNames: ()->
            #Returns a list of component names
            names = []
            
            for name, component of @components
                names.push(name)
                
            return names

    return Entity
)
