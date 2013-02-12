#===========================================================================
#
#Entities - Collection of Entities
#
#===========================================================================
define([], ()->
    class Entities
        constructor: (params)->
            @entities = {}
            @_currentId = 0

        #--------------------------------
        #Entities - add / remove
        #--------------------------------
        add: (entity)->
            @entities[@_currentId] = entity
            @_currentId += 1
            #Update indexes
            return entity
            
        remove: (id)->
            delete @entities[id]
            return @

    return Entities
)
