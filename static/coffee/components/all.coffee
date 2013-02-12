#============================================================================
#
#Components - returns object containing all components
#
#============================================================================
define(['components/vector', 'components/renderer'], (Vector, Renderer)->
    Components = {
        'vector': Vector
        'renderer': Renderer
    }
    return Components
)
