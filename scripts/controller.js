// Generated by CoffeeScript 1.4.0
(function() {

  define(["base_module", "animation"], function(base_module, animation) {
    var controller, elements;
    elements = {
      0: $('#container > div:nth-child(1)')
    };
    return controller = function() {
      var first;
      return first = new base_module(elements[0].children("canvas")[0]);
    };
  });

}).call(this);
