Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    // TODO: Figure where the current topic comes from (options?) update
    // this.is_current.
    this.is_current = false;
  }
});
