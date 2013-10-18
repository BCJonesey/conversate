Support.InflatableModel = {
  inflateExtend: function(attributes) {
    _.extend(attributes, this.inflateAttributes(attributes));
  },

  inflateReturn: function(attributes) {
    return this.inflateAttributes(attributes);
  },

  inflateAtttributes: function(attrs) {
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
};
