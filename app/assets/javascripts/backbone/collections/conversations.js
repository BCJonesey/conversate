ConversateApp.Collections.Conversations = Backbone.Collection.extend({
	model: ConversateApp.Models.Conversation,
  url: function() {
    if (ConversateApp.opened_topic) {
      var root = '/topics/' + ConversateApp.opened_topic;
      if (ConversateApp.opened_conversation) {
        return root + '?conversation=' + ConversateApp.opened_conversation;
      }
      else {
        return root;
      }
    }
    else {
      var root = '/conversations'
      if (ConversateApp.opened_conversation) {
        return root + '?id=' + ConversateApp.opened_conversation;
      }
      return root;
    }


  },
  comparator: function (conversation) {
    return conversation.most_recent_event;
  }
});

