Support.InflatableModel = function(attributes, options) {
  Backbone.Model.apply(this, [attributes, options]);
}

_.extend(Support.InflatableModel.prototype, Backbone.Model.prototype, {
  // Override this in children to properly inflate a model.
  inflateAtttributes = function(attrs) {
    return attrs;
  }
});

Support.InflatableModel.extend = Backbone.Model.extend;
