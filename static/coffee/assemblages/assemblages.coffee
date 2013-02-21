#============================================================================== 
#
#Assemblages
#  Contains outlines for entities
#
#============================================================================== 
define(['entity'], (Entity) ->
    Assemblages = {
        #Each method returns a new entity
        baseCreature: ()->
            entity = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('physics')
                .addComponent('health')
                .addComponent('resources')
                .addComponent('combat')
                .addComponent('randomWalker')
                .addComponent('flocking')
                .addComponent('renderer')
            return entity

        
        human: ()->
            entity = @baseCreature()
                .addComponent('human')
            return entity
        
        zombie: ()->
            entity = @baseCreature()
                .addComponent('zombie')
            return entity
    }
    return Assemblages
)
