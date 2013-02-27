#========================================
#TEST - System - Combat
#NOTE: Damage calculation is defense / 2, if < 0 then it's attack * 0.02
#TODO: better damage algorithm
#========================================
define(['systems/combat', 'systems/world', 'entity', 'entities', 'assemblages/assemblages'], (
    Combat, World, Entity, Entities, Assemblages)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Combat System', ()->
        it('should exist', ()->
            a = new Combat()
            a.should.not.equal(undefined)
        )
    
        #--------------------------------
        #
        #Test getDamage()
        #
        #--------------------------------
        describe('Combat System: getDamage', ()->
            entityHuman = Assemblages.human()
            entityZombie = Assemblages.zombie()
                
            #make them next to each other
            entityHuman.components.position.x = 10
            entityHuman.components.position.y = 10
            
            entityZombie.components.position.x = 10
            entityZombie.components.position.y = 11
            
            entities = new Entities()
                .add(entityHuman)
                .add(entityZombie)
            
            #When they're next to each other, they should fight
            combat = new Combat(entities)
            humanCombat = entityHuman.components.combat
            zombieCombat = entityZombie.components.combat

            it('should return proper damage (attack > defense)', ()->
                humanCombat.attack = 2
                zombieCombat.defense = 1

                #fight - human VS zombie
                damage = combat.calculateDamage(
                    #human
                    humanCombat,
                    #pass in target to fight
                    zombieCombat
                )
                damage.should.equal(1.5)
            )
            it('should return proper damage (attack === defense)', ()->
                #More damage tests 
                humanCombat.attack = 1
                zombieCombat.defense = 1
                damage = combat.calculateDamage(
                    #human
                    humanCombat,
                    #pass in target to fight
                    zombieCombat
                )
                damage.should.equal(0.5)
            )
            it('should return proper damage (attack much > defense)', ()->
                #More damage tests 
                humanCombat.attack = 10
                zombieCombat.defense = 0
                damage = combat.calculateDamage(
                    #human
                    humanCombat,
                    #pass in target to fight
                    zombieCombat
                )
                damage.should.equal(10)
            )
            it('should return proper damage (defense > attack)', ()->
                #More damage tests 
                humanCombat.attack = 0
                zombieCombat.defense = 10
                damage = combat.calculateDamage(
                    #human
                    humanCombat,
                    #pass in target to fight
                    zombieCombat
                )
                damage.should.equal(0)

            )
        )

        #--------------------------------
        #
        #Test fight()
        #
        #--------------------------------
        describe('Combat System: fight()', ()->
            #SETUP
            entityHuman = Assemblages.human()
            entityZombie = Assemblages.zombie()
            zombieHealth = entityZombie.components.health
            humanHealth = entityZombie.components.health
                
            #make them next to each other
            entityHuman.components.position.x = 10
            entityHuman.components.position.y = 10
            entityHuman.components.health.health = 100
            entityHuman.components.combat.attack = 10
            entityHuman.components.combat.baseAttack = 10
            entityHuman.components.combat.defense = 5
            entityHuman.components.combat.baseDefense = 5
            entityHuman.components.combat.attackDelay = 4
            entityHuman.components.combat.baeAttackDelay = 4


            #ZOMBIE
            entityZombie.components.position.x = 10
            entityZombie.components.position.y = 11
            entityZombie.components.health.health = 100
            entityZombie.components.combat.attack = 15
            entityZombie.components.combat.baseAttack = 15
            entityZombie.components.combat.defense = 2
            entityZombie.components.combat.baseDefense = 2
            entityZombie.components.combat.attackDelay = 2
            entityZombie.components.combat.baseAttackDelay = 2
            
            entities = new Entities()
                .add(entityHuman)
                .add(entityZombie)
            
            #When they're next to each other, they should fight
            combat = new Combat(entities)
            humanCombat = entityHuman.components.combat
            zombieCombat = entityZombie.components.combat

            #----------------------------
            #TESTS
            #----------------------------
            it('should properly fight human vs zombie and update delay', ()->
                #Let's test a human vs. zombie fight()
                humanCombat.canAttack.should.be.true
                zombieCombat.canAttack.should.be.true
                humanCombat.attackCounter.should.equal(0)

                #Human fight zombie
                combat.fight(entityHuman, entityZombie)
                humanCombat.canAttack.should.be.false

                #shouldn't affect zombie
                zombieCombat.canAttack.should.be.true
                #should have done 9 damage
                zombieHealth.health.should.equal(91)
                humanCombat.attackCounter.should.equal(humanCombat.attackDelay + 1)
            )
            it('should not let human attack yet, update delay', ()->
                #Let's test a human vs. zombie fight()
                humanCombat.attackCounter.should.equal(humanCombat.attackDelay + 1)
                humanCombat.canAttack.should.be.false

                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(4)
                humanCombat.canAttack.should.be.false
            )
            it('should not execute fight() if canAttack is false', ()->
                #if fight() is called, should return false
                combat.fight(entityHuman,entityZombie).should.be.false
            )
            it('should update attack counter', ()->
                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(3)
                humanCombat.canAttack.should.be.false
            )
            it('should update again', ()->
                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(2)
                humanCombat.canAttack.should.be.false
            )
            it('and update again', ()->
                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(1)
                humanCombat.canAttack.should.be.false
            )
            it('should equal 0 and allow attacking', ()->
                #for good measure, test calling it again
                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(0)
                humanCombat.canAttack.should.be.true

                combat.updateAttackCounter(humanCombat)
                humanCombat.attackCounter.should.equal(0)
                humanCombat.canAttack.should.be.true
            )
        )

        #--------------------------------
        #
        #Test tick()
        #
        #--------------------------------
        describe('tick()', ()->
            describe('Combat System: tick()', ()->
                #SETUP
                entityHuman = Assemblages.human()
                entityZombie = Assemblages.zombie()
                zombieHealth = entityZombie.components.health
                humanHealth = entityZombie.components.health
                    
                #make them next to each other
                entityHuman.components.position.x = 10
                entityHuman.components.position.y = 10
                entityHuman.components.health.health = 100
                entityHuman.components.combat.attack = 10
                entityHuman.components.combat.baseAttack = 10
                entityHuman.components.combat.defense = 5
                entityHuman.components.combat.baseDefense = 5
                entityHuman.components.combat.attackDelay = 4
                entityHuman.components.combat.baeAttackDelay = 4

                #ZOMBIE
                entityZombie.components.position.x = 10
                entityZombie.components.position.y = 11
                entityZombie.components.health.health = 100
                entityZombie.components.combat.attack = 15
                entityZombie.components.combat.baseAttack = 15
                entityZombie.components.combat.defense = 2
                entityZombie.components.combat.baseDefense = 2
                entityZombie.components.combat.attackDelay = 2
                entityZombie.components.combat.baseAttackDelay = 2
                
                entities = new Entities()
                    .add(entityHuman)
                    .add(entityZombie)
                
                #When they're next to each other, they should fight
                combat = new Combat(entities)
                humanCombat = entityHuman.components.combat
                zombieCombat = entityZombie.components.combat
                #Must call world tick to setup grid
                world = new World(entities)
                world.tick()

                it('should fight both the human and zombie', ()->
                    combat.tick(0)
                    #Should update health for both entities
                    # 100 health - (15 zombie attack - 5 human defense)
                    entityHuman.components.health.health.should.equal(87.5)
                    humanCombat.canAttack.should.be.false

                    # 100 health - (10 human attack - 2 zombie defense)
                    entityZombie.components.health.health.should.equal(91)
                    zombieCombat.canAttack.should.be.false

                    #counter should be the delay, as the update is called at end of tick
                    humanCombat.attackCounter.should.equal(4)
                    zombieCombat.attackCounter.should.equal(2)
                )
                it('should not fight when tick is called again', ()->
                    #FIRST TICK, NO FIGHTING
                    #Note: counter is updated in next tick
                    combat.tick(1)
                    zombieCombat.canAttack.should.be.false
                    humanCombat.canAttack.should.be.false

                    entityHuman.components.health.health.should.equal(87.5)
                    entityZombie.components.health.health.should.equal(91)

                    humanCombat.attackCounter.should.equal(3)
                    humanCombat.canAttack.should.be.false
                    zombieCombat.attackCounter.should.equal(1)
                    zombieCombat.canAttack.should.be.false
                )
                it('should not fight when tick is called again again', ()->
                    #SECOND TICK, NO FIGHTING
                    combat.tick(2)
                    entityHuman.components.health.health.should.equal(87.5)
                    entityZombie.components.health.health.should.equal(91)

                    humanCombat.attackCounter.should.equal(2)
                    humanCombat.canAttack.should.be.false
                    zombieCombat.attackCounter.should.equal(0)
                    zombieCombat.canAttack.should.be.true
                )

                it('should allow zombie to attack (two ticks have gone by since first attack)', ()->
                    #THIRD TICK, ZOMBIE FIGHTS - HUMAN NO FIGHT
                    combat.tick(3)
                    entityHuman.components.health.health.should.equal(75)
                    entityZombie.components.health.health.should.equal(91)

                    humanCombat.attackCounter.should.equal(1)
                    humanCombat.canAttack.should.be.false
                    zombieCombat.attackCounter.should.equal(2)
                    zombieCombat.canAttack.should.be.false
                )
                it('should not fight, but ready to', ()->
                    #FOURTH TICK, NO FIGHT
                    combat.tick(4)
                    entityHuman.components.health.health.should.equal(75)
                    entityZombie.components.health.health.should.equal(91)

                    humanCombat.attackCounter.should.equal(0)
                    humanCombat.canAttack.should.be.true
                    zombieCombat.attackCounter.should.equal(1)
                    zombieCombat.canAttack.should.be.false
                )
                it('should let human fight', ()->
                    #FIFTH tick, zombie fight
                    combat.tick(5)
                    entityHuman.components.health.health.should.equal(75)
                    entityZombie.components.health.health.should.equal(82)

                    humanCombat.attackCounter.should.equal(4)
                    humanCombat.canAttack.should.be.false
                    zombieCombat.attackCounter.should.equal(0)
                    zombieCombat.canAttack.should.be.true
                )
            )
        )
    )
)
