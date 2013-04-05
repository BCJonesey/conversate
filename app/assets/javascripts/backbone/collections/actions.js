Structural.Collections.Actions = Backbone.Collection.extend({
  model: Structural.Models.Action,
  initialize: function(data, options) {
    options = options || {};
    if (options.conversation) {
      this.url = Structural.apiPrefix + '/conversations/' + options.conversation + '/actions';
    }
  },
  comparator: 'timestamp',

  focus: function(id) {
    // findWhere is coming in backbone 1.0.0.
    var action = this.where({id: id}).pop();
    if(action) {
      action.focus();
    }
  }
});
