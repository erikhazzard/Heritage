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
            for id, entity of @entities.entities
                entityCounts.all += 1
                if entity.hasComponent('human')
                    entityCounts.human += 1
                if entity.hasComponent('zombie')
                    entityCounts.zombie += 1

            #Log some data
            LoggerHelper.log({
                entityCounts: entityCounts
                tickNum: delta
            })
            return @
            
    
    return Logger
)
