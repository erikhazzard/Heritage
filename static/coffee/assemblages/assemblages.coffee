#============================================================================== 
#
#Assemblages
#  Contains outlines for entities
#
#============================================================================== 
define(['entity'], (Entity) ->
    Assemblages = {
        #Each method returns a new entity
        human: ()->
            entity = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('physics')
                .addComponent('human')
                .addComponent('health')
                .addComponent('combat')
                .addComponent('renderer')
                .addComponent('human')
            return entity
        
        zombie: ()->
            entity = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('physics')
                .addComponent('human')
                .addComponent('health')
                .addComponent('combat')
                .addComponent('renderer')
                .addComponent('zombie')
            return entity
    }
    return Assemblages
)
