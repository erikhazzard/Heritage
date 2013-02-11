(function() {

  define(['entity'], function(Entity) {
    var Game;
    Game = {};
    Game.init = function() {
      return this.a = new Entity();
    };
    return Game;
  });

}).call(this);
