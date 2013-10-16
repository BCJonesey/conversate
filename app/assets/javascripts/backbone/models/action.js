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

        // It's probably because it's a sub part of the json and needs to be parsed out
        // as a real model. Not interested right now. - Nick
        if (this.get('user') instanceof Structural.Models.Participant) {
          // No-op
        }
        else {
          this.set('user', new Structural.Models.Participant(this.get('user')));
        }
      }, this);
    }

    if ((this.get('type') == 'update_users' || this.get('type') == 'update_viewers') &&
        (!this.get('added') || this.get('added').length === 0)) {
      this.set('added', []);
    }

    if ((this.get('type') == 'update_users' || this.get('type') == 'update_viewers') &&
        (!this.get('removed') || this.get('removed').length === 0)) {
      this.set('removed', []);
    }

    if ((this.get('type') == 'update_users' || this.get('type') == 'update_viewers') &&
        this.get('added') &&
        this.get('removed')) {
      this.set('added', new Structural.Collections.Participants(this.get('added')));
      this.set('removed', new Structural.Collections.Participants(this.get('removed')));
    }

    if (this.get('type') === 'update_folders' &&
        !this.get('added')) {
      this.set('added', []);
    }

    if (this.get('type') === 'update_folders' &&
        !this.get('removed')) {
      this.set('removed', []);
    }

    if (this.get('type') === 'update_folders' &&
        this.get('added') &&
        this.get('removed')) {
      this.set('added', new Structural.Collections.Folders(this.get('added')));
      this.set('removed', new Structural.Collections.Folders(this.get('removed')));
    }

    if (this.get('type') == 'move_conversation') {
      this.set('from', new Structural.Models.Folder(this.get('from')));
      this.set('to', new Structural.Models.Folder(this.get('to')));
    }

    if (this.get('type') == 'move_message') {
      this.set('from', new Structural.Models.Conversation(this.get('from')));
      this.set('to', new Structrual.Models.Conversation(this.get('to')));
    }

    if (this.get('text')) {
      this.set('enhanced_text', Support.TextEnhancer.enhance(_.escape(this.get('text'))));
    }
  },
  parse: function (response, options) {

    // Special parsing for update_users actions.
    if (response.added) {
      response.added = _.map(response.added, function (p) {
        return new Structural.Models.Participant(p);
      });
    }
    if (response.removed) {
      response.removed = _.map(response.removed, function (p) {
        return new Structural.Models.Participant(p);
      });
    }

    if (response.text) {
      response.enhanced_text = Support.TextEnhancer.enhance(_.escape(response.text));
    }

    return response;
  },

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  },
  delete: function(user) {
    this.set('type', 'deletion');
    this.set('user', user);
  },
  isMine: function(){
    this.set('isOwnAction', true);
  },
  isUnread: function(mostRecentEventViewed) {
    if (this.get('user').id === Structural._user.id) {
      return false;
    }
    return this.get('timestamp') > mostRecentEventViewed;
  }
});

_.extend(Structural.Models.Action.prototype, Support.HumanizedTimestamp('timestamp'));
