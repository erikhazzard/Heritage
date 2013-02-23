// Generated by CoffeeScript 1.4.0
(function() {

  define(['entity'], function(Entity) {
    var Assemblages;
    Assemblages = {
      baseCreature: function() {
        var entity;
        entity = new Entity().addComponent('world').addComponent('position').addComponent('physics').addComponent('health').addComponent('resources').addComponent('combat').addComponent('randomWalker').addComponent('flocking').addComponent('renderer');
        return entity;
      },
      human: function() {
        var entity;
        entity = this.baseCreature().addComponent('human');
        return entity;
      },
      zombie: function() {
        var entity;
        entity = this.baseCreature().addComponent('zombie');
        return entity;
      }
    };
    return Assemblages;
  });

}).call(this);