Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    var self = this;
    self.set('is_unread', self.get('unread_conversations') > 0);

    // TODO: This gets us the favicon changes for free, but I don't like the asymmetry. Refactor.
    self.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);

    self.conversations = new Structural.Collections.Conversations([], {topicId: self.id});
    self.conversations.on('updated', function(conversation) {

      // One of our conversations has been read. We should lower our expected count.
      // TODO: Rename this whole event chain for clarity.
      var currentUnreadConversationCount = self.get('unread_conversations').length;
      if (currentUnreadConversationCount > 0) {

        // TODO: Wacky bug, figure out what's up with negative unread counts.
        self.filterNewlyReadConversation(conversation);
      }

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
    var countByCalculation = this.conversations.unreadConversationCount();
    var countByState = this.get('unread_conversations').length;
    return countByState > countByCalculation ? countByState : countByCalculation;
  },
  filterNewlyReadConversation: function(conversation) {

    // We want to remove the newly read conversation from our unread list.
    var filteredUnreadConversations = _.reject(this.get('unread_conversations'), function (conversationId) {
      if (conversation.id === conversationId && conversation.unreadCount() === 0) {
        return true;
      }
      return false;
    });

    this.set('unread_conversations', filteredUnreadConversations);
  }
});
