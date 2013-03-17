Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  initialize: function(data, options) {
    if (options.topic) {
      this.url = Structural.apiPrefix + '/topics/' + options.topic + '/conversations';
    }
  },
  comparator: function (conversation) {
    return conversation.most_recent_message;
  }
});

