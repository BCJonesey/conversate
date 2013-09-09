Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',

  initialize: function(options) {
    options = options || {};
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
      console.log('removing', conversation.get('title'), 'from', topic.get('name'));
      topic.conversations.remove(conversation);
    })
  }
});
