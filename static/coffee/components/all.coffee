#============================================================================
#
#Components - returns object containing all components
#
#============================================================================
define(['components/position', 'components/renderer', 'components/physics'], (Position, Renderer, Physics)->
    Components = {
        renderer: Renderer
        
        #World related
        position: Position
        physics: Physics
        
    }
    return Components
)
