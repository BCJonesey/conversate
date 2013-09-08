Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  url: function() {
    return Structural.apiPrefix + '/topics/' + this.topicId + '/conversations';
  },
  initialize: function(data, options) {
    options = options || {};
    this.topicId = options.topicId;
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

  // The topic associated with these conversations is being viewed.
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
