Structural.Collections.Actions = Backbone.Collection.extend({
  model: Structural.Models.Action,
  initialize: function(data, options) {
    if (options.conversation) {
      this.url = Structural.apiPrefix + '/conversations/' + options.conversation + '/actions';
    }
  }
});
