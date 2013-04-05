Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(this.get('participants')));
    }

    this.set('is_unread', this.get('most_recent_message') > this.get('most_recent_viewed'));
    this.set('is_current', false);
  },

  focus: function() {
    this.set('is_current', true);
  }
});
