Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',
  comparator: 'created_at',

  initialize: function(models, options) {
    var self = this;
    options = options || {};
    if (options.isMainCollection) {
      self.on('add', function(topic) {
        topic.on('updated', function() {

          // TODO: Replace with event.
          Structural.updateTitleAndFavicon();

        })
      }, self);

      Structural.on('changeConversation', this.focusAlternates, this);
      Structural.on('clearConversation', this.focusAlternates, this);
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
  // 'Alternate' topics are ones that the given conversation is in, but aren't
  // the current topic.
  focusAlternates: function(conversation) {
    var ids = conversation ? conversation.get('topic_ids') : [];
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
  },

  createNewFolder: function(title) {
    var participants = new Structural.Collections.TopicParticipants();
    participants.add(new Structural.Models.Participant({
      email: Structural._user.get('email'),
      full_name: Structural._user.get('full_name')
    }));

    var folder = new Structural.Models.Topic({
      name: title,
      unread_conversations: 0,
      users: participants
    });
    this.add(folder);

    folder.save({}, {
      success: function(model, response) {
        folder.conversations.topicId = model.id;
        folder.trigger('edit', folder);
      }
    });
  }
});
