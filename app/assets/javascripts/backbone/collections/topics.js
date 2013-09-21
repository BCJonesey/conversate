Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',
  comparator: 'created_at',

  initialize: function(options) {
    var self = this;
    options = options || {};
    self.on('add', function(topic) {
      topic.on('updated', function() {

        // TODO: Replace with event.
        Structural.updateTitleAndFavicon();

      })
    }, self);
  },

  focus: function(id) {
    var topic = this.get(id);
    if(topic) {
      topic.focus();
    }

    this.filter(function(tpc) { return tpc.id != id; }).forEach(function(tpc) {
      tpc.unfocus();
    });
  },
  current: function() {
    return this.where({is_current: true}).pop();
  },

  updateConversationLists: function(conversation, addedTopics, removedTopics) {
    addedTopics.forEach(function(topic) {
      topic.conversations.add(conversation);
    });

    removedTopics.forEach(function(topic) {
      topic.conversations.remove(conversation);
    })
  },

  createNewTopic: function(title) {
    var topic = new new Structural.Models.Topic({});
    // unread_conversations
    // name
    // users << self
  }
});
