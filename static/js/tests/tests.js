(function() {

  define(['entity'], function(Entity) {
    return describe('Entity: Should create', function() {
      return it('should successfully create an entity', function() {
        var a;
        return a = new Entity();
      });
    });
  });

}).call(this);
