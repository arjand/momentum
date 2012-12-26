// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['paper', 'velocity_button'], function(paper, VelocityButton) {
    var BaseModule;
    return BaseModule = (function() {
      var globalConfig, triggerChange, triggerReset;

      triggerReset = function() {
        return false;
      };

      triggerChange = function() {
        return false;
      };

      globalConfig = {
        a: {
          radius: 10,
          color: "brown",
          mass: 10,
          velocity: 10
        },
        b: {
          radius: 5,
          color: "blue",
          mass: 8,
          velocity: 8
        },
        frame: {
          velocity: 0
        },
        general: {
          bottomOffset: 20,
          horizontalOffset: 20
        }
      };

      function BaseModule(canvas) {
        this.eventDelegator = __bind(this.eventDelegator, this);

        this.runAnimation = __bind(this.runAnimation, this);

        this.reset = __bind(this.reset, this);

        this.init = __bind(this.init, this);
        this.canvas = canvas;
        this.paper = new paper.PaperScope();
        this.tool = new this.paper.Tool();
        this.view = new this.paper.View(this.canvas);
        this.paper.setup(this.canvas);
        this.settings = {
          height: this.view.size.height,
          width: this.view.size.width
        };
        this.init();
        this.reset();
        this.eventDelegator();
      }

      BaseModule.prototype.init = function() {
        var _x, _y;
        this.elements = {};
        _y = this.settings.height - globalConfig.general.bottomOffset;
        _x = globalConfig.general.horizontalOffset;
        this.elements = {
          a: {
            defaultPosition: new this.paper.Point(_x, _y),
            currentPosition: new this.paper.Point(_x, _y)
          },
          b: {
            defaultPosition: new this.paper.Point(this.settings.width - _x, _y),
            defaultPosition: new this.paper.Point(this.settings.width - _x, _y)
          }
        };
        this.elements.a.element;
        ({
          element: new this.paper.Path.Circle(new this.paper.Point(this.settings.width - _x, _y), globalConfig.b.radius)
        });
        this.elements.a.fillColor = globalConfig.a.color;
        return this.elements.b.fillColor = globalConfig.b.color;
      };

      BaseModule.prototype.reset = function(full) {
        if (full == null) {
          full = false;
        }
      };

      BaseModule.prototype.runAnimation = function() {};

      BaseModule.prototype.eventDelegator = function() {
        var _this = this;
        this.view.onResize = function(event) {
          return _this.reset();
        };
        this.view.draw = function(event) {};
        return this.tool.onMouseDown = function(event) {
          return console.log("hello world");
        };
      };

      return BaseModule;

    })();
  });

}).call(this);
