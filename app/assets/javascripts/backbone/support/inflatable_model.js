// Inflatable models have other Backbone collections or models as some of their
// attributes.  In order to make an inflatable model, do three things.
//
// 1) Extend from Support.InflatableModel:
//
//    Structural.Models.Foo = Support.InflatableModel.extend({});
//
// 2) Implement inflateAttributes:
//
//    inflateAttributes: function(attrs) {
//      attrs.bars = inflate(Structural.Collections.Bars, attrs.bars);
//      return attrs;
//    }
//
// 3) If you implement initialize or parse, include the appropriate super
//    call:
//
//    this.constructor.__super__.initialize.call(this, attributes, options);
//    response = this.constructor.__super__.parse.call(this, response);

Support.InflatableModel = function(attributes, options) {
  Backbone.Model.apply(this, [attributes, options]);
}

_.extend(Support.InflatableModel.prototype, Backbone.Model.prototype, {
  initialize: function(attributes, options) {
    this.attributes = inflateAttributes(this.attributes);
  },

  parse: function(response) {
    return inflateAttributes(response);
  },

  inflateAtttributes = function(attrs) {
    return attrs;
  },

  inflate: function(type, data) {
    if (data instanceof Backbone.Collection ||
        data instanceof Backbone.Model) {
      return data;
    } else {
      return new type(data);
    }
  },

  // Sometimes we need to do basically the same work but with a different
  // inflated type; this is a convenient way to let us pick the type we're
  // working with.  Note that the types get used like in inflate above:
  //
  // new x(data)
  //
  // The default function here this acts as an identity function.  When called
  // with new, a function with no return value will implicitly return this, but
  // if the function does explicitly return something, that value is used
  // instead.
  chooseType: function(map, key) {
    if (map[key]) {
      return map[key];
    } else {
      return function(x) { return x; };
    }
  }
});

Support.InflatableModel.extend = Backbone.Model.extend;
