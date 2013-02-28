#========================================
#TEST - System - Human
#========================================
define(['systems/human', 'assemblages/assemblages', 'entity', 'entities'], (
    Human, Assemblages, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Human System: Base tests', ()->
        it('Should setup human system', ()->
            human = new Human()
        )
    
        #------------------------------------
        #Update resources
        #------------------------------------
        describe('Human System: Resources tests', ()->
            it('Should calculate health properly', ()->
                entities = new Entities()
                human = new Human(entities)
                #add some entities
                entity1 = Assemblages.human()
                entity1.components.resources.resources = 100
                entity2 = Assemblages.human()
                entities.add(entity1)
                    .add(entity2)

                resources = human.calculateResources(entity1, []) < 100
                #Make sure resources is not the same as the starting value
                resources.should.be.true
                
            )
        )

        #------------------------------------
        #Update combat properties test
        #------------------------------------
        describe('updateCombatProperties()', ()->
            human = new Human()
            entity1 = Assemblages.human()
            entity1.components.combat.attack = 10
            entity1.components.combat.baseAttack = 10
            entity1.components.combat.defense = 10
            entity1.components.combat.baseDefense = 10
            entity1.components.human.age = 1
            it('Should calculate base attack / defense', ()->
                human.updateCombatProperties(entity1, [])
            )
        )

        #------------------------------------
        #Test zombie infection
        #------------------------------------
        describe('updateCombatProperties()', ()->
            human = new Human()
            entity1 = Assemblages.human()
            entity1.components.combat.attack = 10
            entity1.components.combat.baseAttack = 10
            entity1.components.combat.defense = 10
            entity1.components.combat.baseDefense = 10
            entity1.components.human.age = 1
            it('Should check zombie infection', ()->
                human.updateZombieInfection(entity1).should.be.false
            )
        )
    )
)
