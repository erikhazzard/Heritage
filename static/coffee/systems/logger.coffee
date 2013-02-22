#============================================================================
#
#Systems - Logger
#   Handles logging
#
#============================================================================
define(['socket'], (Socket)->
    class Logger
        constructor: (entities)->
            @entities = entities
            return @
        
        tick: (delta)->
            performance = window.performance || {}
            #Log some data
            Socket.emit('logData', {
                numberOfEntitie: @entities.length
                time: new Date()
                performance: performance
            })
            return @
            
    
    return Logger
)
