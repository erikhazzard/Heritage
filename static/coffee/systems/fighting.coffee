#============================================================================
#
#Systems - Fighting
#   Simulates fighting between entities
#
#============================================================================
define([], ()->
    class Fighting
        constructor: (entities)->
            @entities = entities
            return @
        
        #--------------------------------
        #
        #Tick
        #
        #--------------------------------
        tick: (delta)->
            #DO FIGHT HERE
            return @
            
    return Fighting
)
