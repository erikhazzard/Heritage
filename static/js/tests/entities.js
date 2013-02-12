// Generated by CoffeeScript 1.4.0
(function() {

  define(['entities', 'entity'], function(Entities, Entity) {
    return describe('Entities: Setup', function() {
      it('should setup Entities', function() {
        var entities;
        entities = new Entities();
        entities.should.not.equal(void 0);
        return entities._currentId.should.equal(0);
      });
      it('should add entity', function() {
        var entities, entity, entity2;
        entities = new Entities();
        entities.should.not.equal(void 0);
        entities._currentId.should.equal(0);
        entity = new Entity();
        entities.add(entity);
        entities.entities.should.deep.equal({
          '0': entity
        });
        entities._currentId.should.equal(1);
        entity2 = new Entity();
        entities.add(entity2);
        entities.entities.should.deep.equal({
          '0': entity,
          '1': entity2
        });
        return entities._currentId.should.equal(2);
      });
      return it('should remove an entity', function() {
        var entities, entity;
        entities = new Entities();
        entity = new Entity();
        entities.add(entity);
        entities.remove('0');
        entities.entities.should.deep.equal({});
        return entities._currentId.should.equal(1);
      });
    });
  });

}).call(this);
