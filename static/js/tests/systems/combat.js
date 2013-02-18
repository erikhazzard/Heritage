// Generated by CoffeeScript 1.4.0
(function() {

  define(['systems/combat', 'systems/world', 'entity', 'entities'], function(Combat, World, Entity, Entities) {
    describe('Combat System: Base Tests', function() {
      return it('should exist', function() {
        var a;
        a = new Combat();
        return a.should.not.equal(void 0);
      });
    });
    describe('Combat System: Calculate neighbors properly', function() {
      return it('should return proper object', function() {
        var combat, entities, entityHuman, entityZombie, world;
        entityHuman = new Entity().addComponent('world').addComponent('position').addComponent('health').addComponent('human').addComponent('combat');
        entityZombie = new Entity().addComponent('world').addComponent('position').addComponent('health').addComponent('zombie').addComponent('combat');
        entityHuman.components.position.x = 10;
        entityHuman.components.position.y = 10;
        entityZombie.components.position.x = 10;
        entityZombie.components.position.y = 11;
        entities = new Entities().add(entityHuman).add(entityZombie);
        world = new World(entities);
        entityHuman.components.world.neighbors.should.deep.equal([]);
        world.tick();
        entityHuman.components.world.neighbors.should.deep.equal([entityZombie]);
        combat = new Combat(entities);
        return combat.getNeighbors(entityHuman).should.deep.equal({
          zombie: [entityZombie],
          human: []
        });
      });
    });
    return describe('Combat System: Tick() should update properly', function() {
      return it('should properly fight one human vs one zombie', function() {
        var combat, entities, entityHuman, entityZombie;
        entityHuman = new Entity().addComponent('world').addComponent('position').addComponent('health').addComponent('human').addComponent('combat');
        entityZombie = new Entity().addComponent('world').addComponent('position').addComponent('health').addComponent('zombie').addComponent('combat');
        entityHuman.components.position.x = 10;
        entityHuman.components.position.y = 10;
        entityZombie.components.position.x = 10;
        entityZombie.components.position.y = 11;
        entities = new Entities().add(entityHuman).add(entityZombie);
        return combat = new Combat(entities);
      });
    });
  });

}).call(this);