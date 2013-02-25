// Generated by CoffeeScript 1.4.0
(function() {

  define(['components/vector', 'components/physics'], function(Vector, Physics) {
    var Flocking;
    Flocking = (function() {

      function Flocking(entities) {
        this.entities = entities;
        return this;
      }

      Flocking.prototype.separate = function(entity, entities) {
        var count, curDistance, diffVector, flocking, id, key, maxSpeed, position, separationDistance, steer, sumVector, targetEntity, tmpEntities, velocity, _i, _len;
        targetEntity = null;
        curDistance = 0;
        diffVector = null;
        sumVector = new Vector(0, 0);
        count = 0;
        steer = new Vector(0, 0);
        position = entity.components.position;
        flocking = entity.components.flocking;
        maxSpeed = entity.components.physics.maxSpeed;
        velocity = entity.components.physics.velocity;
        separationDistance = flocking.separationDistance || entity.components.physics.mass;
        if (entities.length) {
          tmpEntities = {};
          for (_i = 0, _len = entities.length; _i < _len; _i++) {
            id = entities[_i];
            tmpEntities[id] = this.entities.entities[id];
          }
          entities = tmpEntities;
        }
        for (key in entities) {
          targetEntity = entities[key];
          if (entity.id === targetEntity.id) {
            continue;
          }
          curDistance = position.distance(targetEntity.components.position);
          if (curDistance > 0 && curDistance < separationDistance && (targetEntity !== this)) {
            diffVector = Vector.prototype.subtract(position, targetEntity.components.position);
            diffVector.normalize();
            diffVector.divide(curDistance);
            sumVector.add(diffVector);
            count += 1;
          }
        }
        if (count > 0) {
          sumVector.divide(count);
          sumVector.normalize();
          sumVector.multiply(maxSpeed);
          steer = Vector.prototype.subtract(sumVector, velocity);
          steer.limit(maxSpeed);
        }
        return steer;
      };

      Flocking.prototype.align = function(entity, entities) {
        var count, curDistance, distance, flocking, i, key, maxForce, maxSpeed, physics, position, steer, sum, targetEntity, velocity;
        sum = new Vector(0, 0);
        i = 0;
        curDistance = 0;
        count = 0;
        position = entity.components.position;
        flocking = entity.components.flocking;
        physics = entity.components.physics;
        velocity = physics.velocity;
        maxSpeed = physics.maxSpeed;
        maxForce = physics.maxForce;
        distance = flocking.flockDistance;
        for (key in entities) {
          targetEntity = entities[key];
          if (entity.id === targetEntity.id) {
            continue;
          }
          curDistance = position.distance(targetEntity.components.position);
          if (curDistance <= distance) {
            if (targetEntity.components.physics) {
              sum.add(targetEntity.components.physics.velocity);
              count += 1;
            }
          }
        }
        steer = new Vector(0, 0);
        if (count > 0) {
          sum.divide(count);
          sum.normalize();
          sum.multiply(maxSpeed);
          steer = Vector.prototype.subtract(sum, velocity);
          steer.limit(maxForce);
        }
        return steer;
      };

      Flocking.prototype.cohesion = function(entity, entities) {
        var count, curDistance, distance, flocking, i, key, physics, position, seekForce, steer, sum, targetEntity;
        sum = new Vector(0, 0);
        i = 0;
        curDistance = 0;
        count = 0;
        position = entity.components.position;
        physics = entity.components.physics;
        seekForce = Physics.prototype.seekForce;
        flocking = entity.components.flocking;
        distance = flocking.flockDistance;
        for (key in entities) {
          targetEntity = entities[key];
          if (entity.id === targetEntity.id) {
            continue;
          }
          curDistance = position.distance(targetEntity.components.position);
          if (curDistance <= distance) {
            sum.add(targetEntity.components.position);
            count += 1;
          }
        }
        steer = new Vector(0, 0);
        if (count > 0) {
          sum.divide(count);
          steer = seekForce.call(physics, sum);
        }
        return steer;
      };

      Flocking.prototype.flock = function(entity, entities, multiplier) {
        var align, cohesion, flockComponent, physics, sep;
        multiplier = multiplier || 1;
        flockComponent = entity.components.flocking;
        if (!entities) {
          console.log('ERROR: COMPONENT: FLOCKING');
          console.log('must pass in entities object');
        }
        sep = this.separate(entity, entities);
        align = this.align(entity, entities);
        cohesion = this.cohesion(entity, entities);
        sep.multiply(flockComponent.rules.separate).multiply(multiplier);
        align.multiply(flockComponent.rules.align).multiply(multiplier);
        cohesion.multiply(flockComponent.rules.cohesion).multiply(multiplier);
        physics = entity.components.physics;
        physics.applyForce(sep);
        physics.applyForce(align);
        physics.applyForce(cohesion);
        return this;
      };

      Flocking.prototype.tick = function(delta) {
        var entity, id, _ref;
        _ref = this.entities.entitiesIndex['flocking'];
        for (id in _ref) {
          entity = _ref[id];
          if (entity.hasComponent('human')) {
            this.flock(entity, this.entities.entitiesIndex.human);
          }
          if (entity.hasComponent('zombie')) {
            this.flock(entity, this.entities.entitiesIndex.human, 0.5);
          }
        }
        return this;
      };

      return Flocking;

    })();
    return Flocking;
  });

}).call(this);
