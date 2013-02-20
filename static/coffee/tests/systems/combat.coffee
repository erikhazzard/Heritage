#========================================
#TEST - System - Combat
#========================================
define(['systems/combat', 'systems/world', 'entity', 'entities'], (Combat, World, Entity, Entities)->
    #--------------------------------
    #Basic tests
    #--------------------------------
    describe('Combat System: Base Tests', ()->
        it('should exist', ()->
            a = new Combat()
            a.should.not.equal(undefined)
        )
    )
    
    describe('Combat System: Calculate neighbors properly', ()->
        it('should return proper object', ()->
            entityHuman = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('health')
                .addComponent('human')
                .addComponent('combat')
            entityZombie = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('health')
                .addComponent('zombie')
                .addComponent('combat')
                
            entityHuman.components.position.x = 10
            entityHuman.components.position.y = 10
            
            entityZombie.components.position.x = 10
            entityZombie.components.position.y = 11
            
            entities = new Entities()
                .add(entityHuman)
                .add(entityZombie)

            world = new World(entities)
            entityHuman.components.world.neighbors.should.deep.equal([])
            world.tick()
            entityHuman.components.world.neighbors.should.deep.equal([entityZombie])
            combat = new Combat(entities)
            
            #When getting neighbors for the HUMAN, it should return a single zombie entity
            combat.getNeighbors(entityHuman).should.deep.equal({zombie: [entityZombie], human: [] })
        )
    )
    
    describe('Combat System: Tick() should update properly', ()->
        it('should properly fight one human vs one zombie', ()->
            entityHuman = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('health')
                .addComponent('human')
                .addComponent('combat')

            entityZombie = new Entity()
                .addComponent('world')
                .addComponent('position')
                .addComponent('health')
                .addComponent('zombie')
                .addComponent('combat')
                
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
        )
        
        #--------------------------------
        #Test calculate damage taken
        #--------------------------------
        describe('Combat System: calculateDamageTaken() should return proper value', ()->
            it('should return proper values for two entities fighting', ()->
                entityHuman = new Entity()
                    .addComponent('world')
                    .addComponent('position')
                    .addComponent('health')
                    .addComponent('human')
                    .addComponent('combat')

                entityZombie = new Entity()
                    .addComponent('world')
                    .addComponent('position')
                    .addComponent('health')
                    .addComponent('zombie')
                    .addComponent('combat')
                    
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
                
                damageDealt = combat.calculateDamage(
                    humanCombat, zombieCombat
                )
                damageDealt.should.equal(1)
                
                #Change human combat stats
                humanCombat.defense = 1
                damageDealt = combat.calculateDamage(
                    humanCombat, zombieCombat
                )
                damageDealt.should.equal(0)
                
                #Change human combat stats
                humanCombat.defense = 8
                damageDealt = combat.calculateDamage(
                    humanCombat, zombieCombat
                )
                damageDealt.should.equal(0)

                #Change zombie combat stats
                zombieCombat.attack = 16
                damageDealt = combat.calculateDamage(
                    humanCombat, zombieCombat
                )
                damageDealt.should.equal(8)

            )
        )
        
        #--------------------------------
        #CAN ATTACK / ATTACK SPEED
        #--------------------------------
        describe('Combat System: can attack', ()->
            it('should properly keep track of attack speed / can attack', ()->
                entityHuman = new Entity()
                    .addComponent('world')
                    .addComponent('position')
                    .addComponent('health')
                    .addComponent('human')
                    .addComponent('combat')

                entityZombie = new Entity()
                    .addComponent('world')
                    .addComponent('position')
                    .addComponent('health')
                    .addComponent('zombie')
                    .addComponent('combat')
                    
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
                zombieCombat.attackDelay = 2
                
                #fight
                damageDealt = combat.calculateDamage(
                    humanCombat, zombieCombat
                )
                #get counter to 0
                zombieCombat.canAttack.should.be.false
                zombieCombat.attackTicksRemaining.should.equal(2)

                combat.checkCanAttack(zombieCombat)
                zombieCombat.attackTicksRemaining.should.equal(1)
                zombieCombat.canAttack.should.be.false
                
                #when counter is 0, zombie should be able to attack
                combat.checkCanAttack(zombieCombat)
                zombieCombat.attackTicksRemaining.should.equal(zombieCombat.attackDelay)
                zombieCombat.canAttack.should.be.true
                
                #if it didn't attack, ticks remaning should not change and it 
                #should still be able to attack
                combat.checkCanAttack(zombieCombat)
                zombieCombat.attackTicksRemaining.should.equal(zombieCombat.attackDelay)
                zombieCombat.canAttack.should.be.true
            )
        )
    )
)
