Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(this.get('participants')));
    }

    this.set('is_unread', this.get('unread_count') > 0);
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
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  changeTitle: function(title) {
    this.set('title', title);
  },
  updateUnreadCount: function(actions) {
    this.set('unread_count', actions.filter(function(action) {
      return action.get('is_unread');
    }).length)
  }
});

_.extend(Structural.Models.Conversation.prototype,
         Support.HumanizedTimestamp('most_recent_event'));
