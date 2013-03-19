Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  initialize: function(data, options) {
    options = options || {};
    if (options.topic) {
      this.url = Structural.apiPrefix + '/topics/' + options.topic + '/conversations';
    }
  },
  comparator: 'most_recent_message'
});

