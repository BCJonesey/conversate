Structural.Models.Action = Backbone.Model.extend({
  initialize: function(attributes, options) {
    // TODO: Figure out where the current user is stored, update this.isOwnAction.
    this.isOwnAction = false;
  }
});
