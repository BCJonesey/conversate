Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    var self = this;
    self.set('is_unread', self.get('unread_conversations') > 0);
    self.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);

    self.conversations = new Structural.Collections.Conversations([], {topicId: self.id});
    self.conversations.on('updated', function() {
      console.log('topic updating');
      self.trigger('updated');
    }, self);
  },

  focus: function() {
    this.set('is_current', true);
    this.conversations.viewConversations();
  },
  unfocus: function() {
    this.set('is_current', false);
  },
  unreadConversationCount: function() {
    return this.conversations.unreadConversationCount();
  }
});
