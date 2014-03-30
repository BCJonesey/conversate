Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  url: function() {
    return Structural.apiPrefix + '/folders/' + this.folderId + '/conversations';
  },
  initialize: function(data, options) {
    var self = this;
    options = options || {};
    this.folderId = options.folderId;

    // We want to bind updates on our conversations so that we can alert our folders too.
    self.on('add', function(conversation) {
      conversation.on('updated', function(conversation) {
        self.trigger('updated', conversation);
      }, self);
      conversation.on('archived', function(conversation) {
        self.trigger('archived');
      });
      conversation.on('pinned', function(conversation) {
        self.trigger('pinned');
      });
    }, self);

    Structural.on('readConversation', function(conversation) {

      // Let's see if a conversation in a different folder is one of ours too,
      // and was just read.
      var conversation = self.get(conversation.id);
      if (conversation) {
        conversation.updateMostRecentViewedToNow();
      }
    });

  },
  comparator: function(conversation) {
    return -(conversation.get('most_recent_event'));
  },

  focus: function(id) {
    var conversation = this.get(id);
    if(conversation) {
      conversation.focus();
    }

    this.filter(function(cnv) { return cnv.id != id; }).forEach(function(cnv) {
      cnv.unfocus();
    })
  },

  // The folder associated with these conversations is being viewed.
  viewConversations: function() {
    var self = this;
    var options = {};
    if (this.length === 0) {
      options.reset = true

      // We want to let our views know they can select a conversation since we're loading them lazily.
      options.success = function() {
        self.trigger('conversationsLoadedForFirstTime');
      }
    }
    this.fetch(options);
  },

  unreadConversationCount: function() {
    var count = 0;
    this.forEach(function(conversation) {
      count += conversation.unreadCount() > 0 ? 1 : 0;
    });
    return count;
  }
});
