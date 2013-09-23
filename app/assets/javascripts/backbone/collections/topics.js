Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',
  comparator: 'created_at',

  initialize: function(models, options) {
    var self = this;
    options = options || {};
    if (options.mainCollection) {
      self.on('add', function(topic) {
        topic.on('updated', function() {

          // TODO: Replace with event.
          Structural.updateTitleAndFavicon();

        })
      }, self);

      Structural.on('changeConversation', this.focusAlternates, this);
    }
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
  focusAlternates: function(conversation) {
    var ids = conversation.get('topic_ids');
    this.each(function(topic) {
      if (_.contains(ids, topic.id)) {
        topic.focusAlternate();
      } else {
        topic.unfocusAlternate();
      }
    }, this);
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
  }
});
