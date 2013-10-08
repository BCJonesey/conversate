Structural.Models.Folder = Backbone.Model.extend({
  urlroot: Structural.apiPrefix + '/folders',

  initialize: function(attributes, options) {
    var self = this;
    self.set('is_unread', self.get('unread_conversations') > 0);

    // TODO: This gets us the favicon changes for free, but I don't like the asymmetry. Refactor.
    self.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);

    self.conversations = new Structural.Collections.Conversations([], {folderId: self.id});
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

    // We should listen for one of our conversations being read in a different folder.
    Structural.on('readConversation', function(conversation) {
      self.filterNewlyReadConversation(conversation);
      self.trigger('updated');
    }, self);

    if (this.get('users')) {
      this.set('users', new Structural.Collections.FolderParticipants(this.get('users')));
    }
  },

  focus: function() {
    this.set('is_current', true);
    this.conversations.viewConversations();
  },
  unfocus: function() {
    this.set('is_current', false);
  },
  // A folder is an 'alternate' folder if the current conversation is in it, but
  // the folder isn't the current folder.
  focusAlternate: function() {
    this.set('is_alternate', true);
  },
  unfocusAlternate: function() {
    this.set('is_alternate', false);
  },
  unreadConversationCount: function() {
    var countByCalculation = this.conversations.unreadConversationCount();
    var countByState = this.get('unread_conversations').length;
    return countByState > countByCalculation ? countByState : countByCalculation;
  },
  filterNewlyReadConversation: function(conversation) {
    var self = this;
    // We want to remove the newly read conversation from our unread list.
    var filteredUnreadConversations = _.reject(self.get('unread_conversations'), function (conversationId) {
      if (conversation.id === conversationId) {
        return true;
      }
      return false;
    });

    this.set('unread_conversations', filteredUnreadConversations);
  },

  update: function(name, participants) {
    this.set('name', name);
    this.set('users', participants);
    this.save();
  }
});
