Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.get('participants')) {
      this.set('participants', new Structural.Collections.Participants(this.get('participants')));
    }

    // TODO: Refactor.
    this.actions = new Structural.Collections.Actions({}, {conversation: this.id, user:Structural._user.id});
    //this.actions._findMyMessages();
    this.actions.on('change:unread', function(model, value, options) {
      console.log(value);
      console.log('Unread count changed');
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
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  changeTitle: function(title) {
    this.set('title', title);
  },

  unreadCount: function() {
    return this.actions.unreadCount();
  }
});

_.extend(Structural.Models.Conversation.prototype,
         Support.HumanizedTimestamp('most_recent_event'));
