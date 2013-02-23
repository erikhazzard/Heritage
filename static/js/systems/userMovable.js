// Generated by CoffeeScript 1.4.0
(function() {

  define(['components/vector'], function(Vector) {
    var UserMovable;
    UserMovable = (function() {

      function UserMovable(entities) {
        var _this = this;
        this.entities = entities;
        this.keysPressed = {
          '37': false,
          '38': false,
          '39': false,
          '40': false
        };
        this.inputForce = new Vector(0, 0);
        document.addEventListener('keydown', function(e) {
          var key;
          key = e.keyCode;
          if (key > 36 && key < 41) {
            _this.keysPressed[key] = true;
          }
          return true;
        });
        document.addEventListener('keyup', function(e) {
          var key;
          key = e.keyCode;
          if (key > 36 && key < 41) {
            _this.keysPressed[key] = false;
          }
          return true;
        });
        return this;
      }

      UserMovable.prototype.tick = function(delta) {
        var entity, id, physics, _ref;
        _ref = this.entities.entitiesIndex.userMovable;
        for (id in _ref) {
          entity = _ref[id];
          if (entity.hasComponent('physics')) {
            physics = entity.components.physics;
            this.inputForce.x = 0;
            this.inputForce.y = 0;
            if (this.keysPressed['37'] === true) {
              this.inputForce.x -= 1;
            }
            if (this.keysPressed['38'] === true) {
              this.inputForce.y -= 1;
            }
            if (this.keysPressed['39'] === true) {
              this.inputForce.x += 1;
            }
            if (this.keysPressed['40'] === true) {
              this.inputForce.y += 1;
            }
            physics.applyForce(this.inputForce.multiply(2));
            if (this.inputForce.x === 0 && this.inputForce.y === 0) {
              physics.velocity.multiply(0);
            }
          }
        }
        return true;
      };

      return UserMovable;

    })();
    return UserMovable;
  });

}).call(this);