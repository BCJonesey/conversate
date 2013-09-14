Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    var self = this;
    self.set('is_unread', self.get('unread_conversations') > 0);

    // TODO: This gets us the favicon changes for free, but I don't like the asymmetry. Refactor.
    self.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);

    self.conversations = new Structural.Collections.Conversations([], {topicId: self.id});
    self.conversations.on('updated', function() {
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
    var countByState = this.get('unread_conversations');
    return countByState > countByCalculation ? countByState : countByCalculation;
  }
});
