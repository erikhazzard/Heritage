#========================================
#TEST - System - spawner
#========================================
define(['systems/spawner', 'entity', 'entities', 'assemblages/assemblages'], (
    Spawner, Entity, Entities, Assemblages)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Spawner System', ()->
        entityMale = Assemblages.human()
        entityFemale = Assemblages.human()
            
        #make them next to each other
        entityMale.components.position.x = 10
        entityMale.components.position.y = 10
        entityMale.components.human.age = 22
        entityMale.components.human.sex = 'male'
        
        entityFemale.components.position.x = 10
        entityFemale.components.position.y = 11
        entityFemale.components.human.age = 22
        entityFemale.components.human.sex = 'female'
        
        entities = new Entities()
            .add(entityMale)
            .add(entityFemale)
        spawner = new Spawner(entities)

        #--------------------------------    
        #Find mate
        #--------------------------------    
        describe('findMate()', ()->
            #always find first mate
            entityFemale.components.human.findMateChance = 1
            
            it('should have no mate', ()->
                hasMate = entityFemale.components.human.mateId?
                hasMate.should.be.false
            )
            it('should find a mate', ()->
                spawner.findMate(entityFemale, [entityMale.id]).should.be.true
            )
            it('female and males should be mates', ()->
                hasMate = entityFemale.components.human.mateId?
                hasMate.should.be.true
                #Male and female should be mates
                entityFemale.components.human.mateId.should.equal(
                    entityMale.id
                )
                entityMale.components.human.mateId.should.equal(
                    entityFemale.id
                )
            )
        )

        #--------------------------------    
        #Concieve
        #--------------------------------    
        describe('conceive()', ()->
            #TESTS FOR GETTING ENTITY PREGNANT
            it('should not get pregnant if chance is 0', ()->
                entityFemale.components.human.pregnancyChance = 0
                entityFemale.components.human.isPregnant.should.be.false
                spawner.conceive(entityFemale, [entityMale.id])
                entityFemale.components.human.isPregnant.should.be.false
            )
            
            it('should get pregnant if chance is 1', ()->
                entityFemale.components.human.pregnancyChance = 1
                entityFemale.components.human.isPregnant.should.be.false
                spawner.conceive(entityFemale, [entityMale.id])
                #When human is pregnant, the gestationTimeLeft should equal the 
                #   gestationLength
                entityFemale.components.human.isPregnant.should.be.true
                entityFemale.components.human.gestationTimeLeft.should.equal(
                    entityFemale.components.human.gestationLength
                )
            )
        )
        
        #--------------------------------    
        #Make Baby
        #--------------------------------    
        describe('makeBaby()', ()->
            #TESTS FOR MAKING A BABY
            it('should make a baby when it can', ()->

            )
        )
    )
)
