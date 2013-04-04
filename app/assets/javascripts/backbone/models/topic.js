Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    this.set('is_current', false);
    this.set('is_unread', this.get('unread_conversations') > 0);
  },

  focus: function() {
    this.set('is_current', true);
  }
});
