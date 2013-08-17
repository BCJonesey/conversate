Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    var self = this;
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(this.get('participants')));
    }

    this.actions = new Structural.Collections.Actions([], {conversation: this.id, user:Structural._user.id});
    this.actions.on('unreadCountChanged', function() {
      self.trigger('updated');
    });
    Structural.on('changeConversation', function(conversation) {
      if (conversation === self) {
        self.set('most_recent_viewed', new Date());

        // TODO: Might want to consider remove this, but how?
        self.set('unread_count', 0);
      }
      self.trigger('updated');
    });

  },
  parse: function (response, options) {

    // This gets used later in a template so we need real models from our response.
    response.participants = _.map(response.participants, function (p) {
      return new Structural.Models.Participant(p);
    });
    return response;
  },

  focus: function() {
    this.set('is_current', true);
    this.actions.fetch();
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  changeTitle: function(title) {
    this.set('title', title);
  },

  unreadCount: function() {
    var countByActions = this.actions.unreadCount(this.get('most_recent_viewed'));
    var countByConversation = this.get('unread_count');
    return countByConversation > countByActions ? countByConversation : countByActions;
  }
});

_.extend(Structural.Models.Conversation.prototype,
         Support.HumanizedTimestamp('most_recent_event'));
