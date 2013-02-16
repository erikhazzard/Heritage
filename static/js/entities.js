// Generated by CoffeeScript 1.4.0
(function() {

  define(['events'], function(events) {
    var Entities;
    Entities = (function() {

      function Entities(params) {
        var _this = this;
        this.entities = {};
        this._currentId = 0;
        this.entitiesIndex = {};
        events.on('entity:component:added', function(data) {
          return _this.addToIndex(data.componentName, data.id);
        });
        events.on('entity:component:removed', function(data) {
          return _this.removeFromIndex(data.componentName, data.id);
        });
        return this;
      }

      Entities.prototype.addToIndex = function(componentName, entityId) {
        if (!this.entitiesIndex[componentName]) {
          this.entitiesIndex[componentName] = {};
        }
        if (entityId !== void 0 && entityId !== null) {
          this.entitiesIndex[componentName][entityId] = this.entities[entityId];
        }
        return this.entitiesIndex;
      };

      Entities.prototype.removeFromIndex = function(componentName, entityId) {
        if (!this.entitiesIndex[componentName]) {
          this.entitiesIndex[componentName] = {};
        }
        if (entityId !== void 0 && entityId !== null) {
          delete this.entitiesIndex[componentName][entityId];
        }
        return this.entitiesIndex;
      };

      Entities.prototype.add = function(entity) {
        var component, name, _ref;
        this.entities[this._currentId] = entity;
        entity.id = this._currentId;
        this._currentId += 1;
        _ref = entity.components;
        for (name in _ref) {
          component = _ref[name];
          this.addToIndex(name, entity.id);
        }
        return this;
      };

      Entities.prototype.remove = function(target) {
        var component, id, key, _ref;
        if (target.id !== void 0) {
          id = target.id;
        } else {
          id = target;
        }
        _ref = this.entitiesIndex;
        for (key in _ref) {
          component = _ref[key];
          delete component[id];
        }
        if (this.entities[id] && this.entities[id].remove) {
          this.entities[id].remove();
        }
        delete this.entities[id];
        return this;
      };

      Entities.prototype._getEntities = function(componentName) {
        var entitiesByComponent, entity, id, _ref;
        entitiesByComponent = {};
        _ref = this.entities;
        for (id in _ref) {
          entity = _ref[id];
          if (entity.hasComponent(componentName)) {
            entitiesByComponent[id] = entity;
          }
        }
        return entitiesByComponent;
      };

      return Entities;

    })();
    return Entities;
  });

}).call(this);
