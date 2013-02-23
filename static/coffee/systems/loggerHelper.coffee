#============================================================================
#
#Systems - Logger Helper
#   Wraps socket calls to help with logging
#
#============================================================================
define(['socket'], (Socket)->
    LoggerHelper = {
        disableLogging: false
        
        #Log some data
        log: (options)->
            options = options || {}
            #If socket can't be found, return false
            if not Socket
                return false
    
            #Set some things to always log
            performance = window.performance || {}
            
            loggerOptions = {
                sessionid: Socket.socket.sessionid
                time: new Date()
                performance: performance
            }
            
            #Extend the logger options object
            for key, option of options
                loggerOptions[key] = option
                
            if not LoggerHelper.disableLogging
                Socket.emit('logData', loggerOptions)

            return true
        
    }
    return LoggerHelper
)
