(function() {

  define(['vector'], function(Vector) {
    var Entity;
    Entity = (function() {

      function Entity(params) {
        params = params || {};
        this.position = params.position || new Vector(Math.random() * 200 | 0, Math.random() * 200 | 0);
        this.velocity = params.velocity || new Vector(0, 0);
        this.acceleration = params.acceleration || new Vector(0, 0);
        this.color = params.color;
        if (!this.color) {
          this.color = 'rgba(' + (Math.random() * 255 | 0);
          +',' + (Math.random() * 255 | 0) + ',';
          +(Math.random() * 255 | 0);
          +',';
          +'1)';
        }
        this.health = params.health || 80;
        this.mass = params.mass || (Math.random() * 20 | 0) + 5;
        this.maxSpeed = params.maxSpeed || 8;
        this.maxForce = params.maxForce || .5;
        this.ruleAlign = Math.random() * 2;
        this.ruleCohesion = Math.random() * 2;
        this.ruleSeparate = Math.random() * 2;
        return this;
      }

      Entity.prototype.update = function() {
        this.velocity.add(this.acceleration);
        this.velocity.limit(this.maxSpeed);
        this.position.add(this.velocity);
        this.checkEdges();
        return this.acceleration.multiply(0);
      };

      Entity.prototype.draw = function() {
        context.save();
        context.fillStyle = this.color;
        context.fillRect(this.position.x - (this.mass / 2), this.position.y - (this.mass / 2), this.mass, this.mass);
        return context.restore();
      };

      Entity.prototype.checkEdges = function() {
        if (this.position.x >= width) {
          this.position.x = this.position.x % width;
        } else if (this.position.x < 0) {
          this.position.x = width - 1;
        }
        if (this.position.y >= height) {
          return this.position.y = this.position.y % height;
        } else if (this.position.y < 0) {
          return this.position.y = height - 1;
        }
      };

      Entity.prototype.applyForce = function(force) {
        return this.acceleration.add(force.copy());
      };

      Entity.prototype.seekForce = function(target, flee, maxForceDistance) {
        var curDistance, desiredVelocity, distance, magnitude, maxDistance, scale, steer, steerLine;
        maxDistance = 100;
        if (target && target.position) target = target.position;
        desiredVelocity = Vector.prototype.subtract(target, this.position);
        if (maxForceDistance) {
          curDistance = this.position.distance(target);
          if (curDistance <= 0 || curDistance > maxForceDistance) {
            return new Vector(0, 0);
          }
        }
        distance = desiredVelocity.magnitude();
        magnitude = 0;
        scale = d3.scale.linear().domain([0, maxDistance]).range([0, this.maxSpeed]);
        if (distance < maxDistance) {
          magnitude = scale(distance);
          desiredVelocity.multiply(magnitude);
        } else {
          desiredVelocity.multiply(this.maxSpeed);
        }
        steer = Vector.prototype.subtract(desiredVelocity, this.velocity);
        steerLine = Vector.prototype.add(this.position, steer);
        steer.limit(this.maxForce);
        if (flee) steer.multiply(-1);
        return steer;
      };

      Entity.prototype.cosLookup = {};

      Entity.prototype.sinLookup = {};

      Entity.prototype.walkForce = function(futureDistance, radius) {
        var cos, cosLookup, force, futurePosition, randomAngle, scale, sin, sinLookup, target, x, y;
        futureDistance = futureDistance || 40;
        radius = radius || 30;
        futurePosition = this.velocity.copy();
        futurePosition.normalize();
        if (futurePosition.magnitude() < 0.1) {
          futurePosition.add(new Vector((Math.random() * 3 | 0) - 1 || 1, (Math.random() * 3 | 0) - 1 || 1));
        }
        futurePosition.multiply(futureDistance);
        scale = d3.scale.linear().domain([0, 1]).range([0, 360]);
        randomAngle = Math.random() * 361 | 0;
        cosLookup = Entity.prototype.cosLookup;
        if (!cosLookup[randomAngle]) {
          cosLookup[randomAngle] = Math.cos(randomAngle);
        }
        cos = cosLookup[randomAngle];
        sinLookup = Entity.prototype.sinLookup;
        if (!sinLookup[randomAngle]) {
          sinLookup[randomAngle] = Math.sin(randomAngle);
        }
        sin = sinLookup[randomAngle];
        x = radius * cos;
        y = radius * sin;
        target = new Vector(x, y);
        target.add(this.position);
        force = this.seekForce(target);
        return force;
      };

      Entity.prototype.separate = function(entities) {
        var count, curDistance, diffVector, entity, separationDistance, steer, sumVector, targetEntity, _i, _len;
        separationDistance = this.mass;
        targetEntity = null;
        curDistance = 0;
        diffVector = null;
        sumVector = new Vector(0, 0);
        count = 0;
        steer = new Vector(0, 0);
        for (_i = 0, _len = entities.length; _i < _len; _i++) {
          entity = entities[_i];
          targetEntity = entities[entity];
          curDistance = this.position.distance(targetEntity.position);
          if (curDistance > 0 && curDistance < separationDistance && (targetEntity(!this))) {
            diffVector = Vector.prototype.subtract(this.position, targetEntity.position);
            diffVector.normalize();
            diffVector.divide(curDistance);
            sumVector.add(diffVector);
            count += 1;
          }
        }
        if (count > 0) {
          sumVector.divide(count);
          sumVector.normalize();
          sumVector.multiply(this.maxSpeed);
          steer = Vector.prototype.subtract(sumVector, this.velocity);
          steer.limit(this.maxSpeed);
        }
        return steer;
      };

      Entity.prototype.align = function(entities) {
        var count, curDistance, distance, entity, i, steer, sum, _i, _len;
        distance = 40;
        sum = new Vector(0, 0);
        i = 0;
        entity = null;
        curDistance = 0;
        count = 0;
        for (_i = 0, _len = entities.length; _i < _len; _i++) {
          i = entities[_i];
          entity = entities[i];
          curDistance = this.position.distance(entity.position);
          if (curDistance <= distance) {
            sum.add(entity.velocity);
            count += 1;
          }
        }
        steer = new Vector(0, 0);
        if (count > 0) {
          sum.divide(count);
          sum.normalize();
          sum.multiply(this.maxSpeed);
          steer = Vector.prototype.subtract(sum, this.velocity);
          steer.limit(this.maxForce);
        }
        return steer;
      };

      Entity.prototype.cohesion = function(entities) {
        var count, curDistance, distance, entity, i, steer, sum, _i, _len;
        sum = new Vector(0, 0);
        i = 0;
        entity = null;
        distance = 40;
        curDistance = 0;
        count = 0;
        for (_i = 0, _len = entities.length; _i < _len; _i++) {
          i = entities[_i];
          entity = entities[i];
          curDistance = this.position.distance(entity.position);
          if (curDistance <= distance) {
            sum.add(entity.position);
            count += 1;
          }
        }
        steer = new Vector(0, 0);
        if (count > 0) {
          sum.divide(count);
          steer = this.seekForce(sum);
        }
        return steer;
      };

      Entity.prototype.flock = function(entities) {
        var align, cohesion, sep;
        sep = this.separate(entities);
        align = this.align(entities);
        cohesion = this.cohesion(entities);
        sep.multiply(this.ruleSeparate);
        align.multiply(this.ruleAlign);
        cohesion.multiply(this.ruleCohesion);
        this.applyForce(sep);
        this.applyForce(align);
        this.applyForce(cohesion);
        return this;
      };

      return Entity;

    })();
    return Entity;
  });

}).call(this);
