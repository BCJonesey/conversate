Support.InflatableModel = function(attributes, options) {
  Backbone.Model.apply(this, [attributes, options]);
}

_.extend(Support.InflatableModel.prototype, Backbone.Model.prototype, {
  // Override this in children to properly inflate a model.
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
  }
});

Support.InflatableModel.extend = Backbone.Model.extend;
