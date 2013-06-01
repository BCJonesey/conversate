Structural.Models.Action = Backbone.Model.extend({
  initialize: function(attributes, options) {
    // TODO: Figure out where the current user is stored, update this.isOwnAction.
    this.set('isOwnAction', false);

    if (this.get('user')) {
      this.set('user', new Structural.Models.Participant(this.get('user')));
    }

    if (this.get('type') == 'update_users' &&
        (!this.get('added') || this.get('added').length === 0)) {
      this.set('added', []);
    }

    if (this.get('type') == 'update_users' &&
        (!this.get('removed') || this.get('removed').length === 0)) {
      this.set('removed', []);
    }

    if (this.get('type') == 'update_users' &&
        this.get('added') &&
        this.get('removed')) {
      this.set('added', new Structural.Collections.Participants(this.get('added')));
      this.set('removed', new Structural.Collections.Participants(this.get('removed')));
    }

    if (this.get('type') == 'move_conversation') {
      this.set('from', new Structural.Models.Topic(this.get('from')));
      this.set('to', new Structural.Models.Topic(this.get('to')));
    }

    if (this.get('type') == 'move_message') {
      this.set('from', new Structural.Models.Conversation(this.get('from')));
      this.set('to', new Structrual.Models.Conversation(this.get('to')));
    }
  },

  // This seems to make things better than having no validate functions, which
  // should be the case.
  validate: function() {},

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  },
  markRead: function() {
    this.set('is_unread', false);
  },
  markUnread: function() {
    this.set('is_unread', true);
  },
  delete: function(user) {
    this.set('type', 'deletion');
    this.set('user', user);
  }
});

_.extend(Structural.Models.Action.prototype, Support.HumanizedTimestamp('timestamp'));
