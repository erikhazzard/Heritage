// Generated by CoffeeScript 1.4.0
(function() {

  define(['systems/world', 'components/world', 'entity', 'entities', 'assemblages/assemblages'], function(WorldSystem, WorldComponent, Entity, Entities, Assemblages) {
    return describe('World System', function() {
      var entities, entityHuman, entityZombie, entityZombie2, humanWorld, world;
      entityHuman = Assemblages.human();
      entityZombie = Assemblages.zombie();
      entityZombie2 = Assemblages.zombie();
      entities = new Entities().add(entityHuman).add(entityZombie).add(entityZombie2);
      entityHuman.components.position.x = 10;
      entityHuman.components.position.y = 10;
      entityZombie.components.position.x = 12;
      entityZombie.components.position.y = 12;
      entityZombie2.components.position.x = 40;
      entityZombie2.components.position.y = 40;
      world = new WorldSystem(entities);
      world.tick();
      WorldComponent.cellSize = 4;
      humanWorld = entityHuman.components.world;
      return describe('getNeighbors tests', function() {
        it('when radius is 0, should only get neighbors which occupy same cell', function() {
          WorldComponent.cellSize = 1;
          world.tick();
          humanWorld.getNeighbors(0).should.deep.equal([]);
          return humanWorld.neighborsByRadius[0].should.deep.equal([]);
        });
        it('should get a single neighbor when radius is 1', function() {
          WorldComponent.cellSize = 2;
          world.tick();
          humanWorld.getNeighbors(1).should.deep.equal([entityZombie.id]);
          return humanWorld.neighborsByRadius[1].should.deep.equal([entityZombie.id]);
        });
        it('should get all neighbors when radius is big enough', function() {
          var neighbors;
          WorldComponent.cellSize = 10;
          world.tick();
          neighbors = [entityZombie.id, entityZombie2.id];
          humanWorld.getNeighbors(3).should.deep.equal(neighbors);
          humanWorld.neighborsByRadius[3].should.deep.equal(neighbors);
          humanWorld.getNeighbors(2).should.deep.equal([entityZombie.id]);
          return humanWorld.neighborsByRadius[2].should.deep.equal([entityZombie.id]);
        });
        return it('should not return duplicate IDs when radius is huge', function() {
          var neighbors;
          WorldComponent.cellSize = 1000;
          world.tick();
          neighbors = [entityZombie.id, entityZombie2.id];
          humanWorld.getNeighbors(30).should.deep.equal(neighbors);
          return humanWorld.neighborsByRadius[30].should.deep.equal(neighbors);
        });
      });
    });
  });

}).call(this);
