Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    var self = this;
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(
        this.get('participants'),
        {
          conversation: self.id
        })
      );
    }

    this.actions = new Structural.Collections.Actions([], {conversation: this.id, user:Structural._user.id});
    this.actions.on('add', function() {
      self.trigger('updated');
    })
    Structural.on('changeConversation', function(conversation) {
      if (conversation === self) {
        // This has the side effect that we'll also redraw for free.
        self.updateMostRecentViewedToNow();
      }
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
  },

  // Sets our local values immediately and lets the server side participants collection know
  // for persistence. TODO: Most recent viewed is funky enough that it will probably require
  // a refactor at some point.
  updateMostRecentViewedToNow: function() {
    var self = this;
    self.set('most_recent_viewed', (new Date()).valueOf());
    self.set('unread_count', 0);

    self.get('participants').each( function(participant) {
      if (Structural._user.id === participant.id) {
        // The server-side function has a side effect in that it will update most recent viewed
        // for this conversation and user, which will be close enough to the time we want.
        participant.save(
          {
            most_recent_viewed: self.get('most_recent_viewed')
          }
        );
      }
    })
    self.trigger('updated');
  }
});

_.extend(Structural.Models.Conversation.prototype,
         Support.HumanizedTimestamp('most_recent_event'));
