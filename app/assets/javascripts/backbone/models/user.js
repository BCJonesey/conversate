Structural.Models.User = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      this.set('name', this.get('full_name') || this.get('email'));
    }
  }
});
