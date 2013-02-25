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
                .addComponent('combat')
                .addComponent('randomWalker')
                .addComponent('flocking')
                .addComponent('renderer')
            return entity

        
        human: ()->
            entity = @baseCreature()
                .addComponent('human')
                #testing:
                #.removeComponent('physics')
                
            #Give humans attack / defense
            entity.components.combat.defense = d3.random.normal(10,5)() | 0
            entity.components.combat.attack = d3.random.normal(10,5)() | 0

            return entity
        
        zombie: ()->
            entity = @baseCreature()
                .addComponent('zombie')
            #Zombies have generally more attack than defense
            entity.components.combat.defense = d3.random.normal(0,5)() | 0
            entity.components.combat.attack = d3.random.normal(15,5)() | 0
            return entity
    }
    return Assemblages
)
