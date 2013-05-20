Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(this.get('participants')));
    }

    this.set('is_unread', this.get('unread_count') > 0);
    //this.set('is_current', false);
  },

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  changeTitle: function(title) {
    this.set('title', title);
  }
});
