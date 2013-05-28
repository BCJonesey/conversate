Structural.Models.Participant = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      this.set('name', this.get('full_name') || this.get('email'));
    }
  },
  updateReadTimestamp: function(timestamp) {
    this.set('most_recent_viewed', timestamp);
    this.save();
  }
});
