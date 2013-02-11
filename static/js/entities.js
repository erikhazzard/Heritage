(function() {

  define([], function() {
    var Entities;
    Entities = (function() {

      function Entities(params) {
        this.entities = [];
      }

      Entities.prototype.add = function(params) {
        params = params || {};
        return this.entities.push(new Entity(params));
      };

      Entities.prototype.remove = function(i) {
        return this.entities.splice(i, 1);
      };

      Entities.prototype.applyForce = function(force) {
        var entity, _i, _len, _ref, _results;
        _ref = this.entities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          _results.push(this.entities[entity].applyForce(force));
        }
        return _results;
      };

      return Entities;

    })();
    return Entities;
  });

}).call(this);
