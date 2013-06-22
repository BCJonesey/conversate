Structural.Models.Action = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.get('user')) {
      this.set('user', new Structural.Models.Participant(this.get('user')));

      // When syncing with the server, the user property has a habit of
      // being overwritten and not replaced with a model.
      this.on('change:user', function() {
        // I swear to god, when I inverted this condition it was executing the
        // wrong path.  The next time you read this comment try re-doing this
        // and maybe the stars will be in a better alignment.
        if (this.get('user') instanceof Structural.Models.Participant) {
          // No-op
        }
        else {
          this.set('user', new Structural.Models.Participant(this.get('user')));
        }
      }, this);
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
  },
  isMine: function(){
    this.set('isOwnAction', true);
  }
});

_.extend(Structural.Models.Action.prototype, Support.HumanizedTimestamp('timestamp'));
