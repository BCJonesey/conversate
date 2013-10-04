Structural.Models.Status = Backbone.Model.extend({
  url: Structural.apiPrefix + '/status',
  initialize: function(data, options) {
    options = options || {};
    this.on('change:global_most_recent_action', this.updateEverything, this);
  },
  updateEverything: function() {
    // TODO: Update all the data in the app when something changed.
  }
})
