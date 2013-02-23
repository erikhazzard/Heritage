#============================================================================
#
#Systems - Logger
#   Handles logging
#
#============================================================================
define(['systems/loggerHelper'], (LoggerHelper)->
    class Logger
        constructor: (entities)->
            @entities = entities
            return @
        
        tick: (delta)->
            performance = window.performance || {}
            entityCounts = {
                all: 0
                human: 0
                zombie: 0
            }
            entityCounts.human = Object.keys(@entities.entitiesIndex.human).length
            entityCounts.zombie = Object.keys(@entities.entitiesIndex.zombie).length
            
            #Log some data
            LoggerHelper.log({
                entityCounts: entityCounts
                tickNum: delta
            })
            return @
            
    
    return Logger
)
