#============================================================================== 
#
#Assemblages
#  Contains outlines for entities
#
#============================================================================== 
define(['entity', 'lib/d3'], (Entity, d3) ->
    Assemblages = {
        #Each method returns a new entity
        baseCreature: ()->
            entity = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('physics')
                .addComponent('health')
                .addComponent('resources')
                .addComponent('randomWalker')
                .addComponent('flocking')
                .addComponent('renderer')
            return entity

        
        human: ()->
            entity = @baseCreature()
                .addComponent('human')
                .addComponent('combat', {
                    defense: d3.random.normal(12,5)() | 0
                    attack: d3.random.normal(12,5)() | 0
                })

            return entity
        
        zombie: ()->
            entity = @baseCreature()
                .addComponent('zombie')
                .addComponent('combat', {
                    defense: d3.random.normal(0,5)() | 0
                    attack: d3.random.normal(20,5)() | 0
                })
                
            return entity
    }
    return Assemblages
)
