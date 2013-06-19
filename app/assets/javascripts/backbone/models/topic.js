Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    //this.set('is_current', false);
    this.set('is_unread', this.get('unread_conversations') > 0);
  },

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  updateUnreadCount: function(conversations) {
    this.set('unread_conversations', conversations.filter(function(conversation) {
      return conversation.get('unread_count') > 0;
    }).length);
  }
});
