// Generated by CoffeeScript 1.4.0
(function() {

  define(['systems/spawner', 'entity', 'entities', 'assemblages/assemblages'], function(Spawner, Entity, Entities, Assemblages) {
    return describe('Spawner System', function() {
      var entities, entityFemale, entityMale, spawner;
      entityMale = Assemblages.human();
      entityFemale = Assemblages.human();
      entityMale.components.position.x = 10;
      entityMale.components.position.y = 10;
      entityMale.components.human.age = 22;
      entityMale.components.human.sex = 'male';
      entityFemale.components.position.x = 10;
      entityFemale.components.position.y = 11;
      entityFemale.components.human.age = 22;
      entityFemale.components.human.sex = 'female';
      entityFemale.components.human.findMateChance = 1;
      entityFemale.components.human.pregnancyChance = 1;
      entities = new Entities().add(entityMale).add(entityFemale);
      spawner = new Spawner(entities);
      describe('findMate()', function() {
        it('should have no mate', function() {
          var hasMate;
          hasMate = entityFemale.components.human.mateId != null;
          return hasMate.should.be["false"];
        });
        it('should find a mate', function() {
          return spawner.findMate(entityFemale, [entityMale.id]).should.be["true"];
        });
        return it('female and males should be mates', function() {
          var hasMate;
          hasMate = entityFemale.components.human.mateId != null;
          hasMate.should.be["true"];
          entityFemale.components.human.mateId.should.equal(entityMale.id);
          return entityMale.components.human.mateId.should.equal(entityFemale.id);
        });
      });
      describe('conceive()', function() {});
      return describe('makeBaby()', function() {});
    });
  });

}).call(this);
