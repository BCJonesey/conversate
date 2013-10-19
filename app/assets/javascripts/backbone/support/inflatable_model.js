// There are four things you need to do to properly inflate a model.
//
// 1) Mix Support.InflatableModel in to your model constructor:
//
//     _.extend(Structural.Models.Foo.prototype, Support.InflatableModel);
//
// 2) Implement inflatableAttributes in your model.  You should be using inflate
//    any time you want to create a Backbone object from JSON data:
//
//     inflateAttributes: function(attrs) {
//       attrs.bar = this.inflate(Structural.Models.Bar, attrs.bar);
//       return attrs;
//     }
//
// 3) Include this line in your model's initialize function (before any code
//    expects inflated data):
//
//     this.inflateExtend(this.attributes);
//
// 4) Include this line in your model's parse function:
//
//     response = this.inflateReturn(response);

Support.InflatableModel = {
  inflateExtend: function(attributes) {
    _.extend(attributes, this.inflateAttributes(_.clone(attributes)));
  },

  inflateReturn: function(attributes) {
    return this.inflateAttributes(_.clone(attributes));
  },


  inflate: function(type, data, options) {
    // If not passed, options is undefined
    options = _.extend({}, options);
    if (data instanceof Backbone.Collection ||
        data instanceof Backbone.Model) {
      return data;
    } else {
      return new type(data, options);
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
};
