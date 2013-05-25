Structural.Collections.Actions = Backbone.Collection.extend({
  model: Structural.Models.Action,
  url: function() {
    return Structural.apiPrefix + '/conversations/' + this.conversationId + '/actions';
  },
  initialize: function(data, options) {
    options = options || {};
    this.conversationId = options.conversation;
    this.userId = options.user;
    this.on('reset', this._lieAboutActionsSoItLooksNiceToHumans, this);
    this.on('reset', this.calculateUnreadedness, this);
  },
  comparator: 'timestamp',

  _lieAboutActionsSoItLooksNiceToHumans: function() {
    this.each(function(action) {
      if (action.get('type') === 'deletion') {
        var target = this.where({id: action.get('msg_id')})[0];
        if(target) {
          target.delete(action.get('user'));
          this.remove(action);
        }
      }
      // TODO: Do something similar for moved messages.
    }, this);
  },

  focus: function(id) {
    // findWhere is coming in backbone 1.0.0.
    var action = this.where({id: id}).pop();
    if(action) {
      action.focus();
    }

    this.filter(function(act) { return act.id != id; }).forEach(function(act) {
      act.unfocus();
    });
  },

  createRetitleAction: function(title, user) {
    this._newAction({
      type: 'retitle',
      title: title,
      user: {
        name: user.get('name'),
        id: user.id
      }
    });
  },
  createUpdateUserAction: function(added, removed, user) {
    this._newAction({
      type: 'update_users',
      user: {
        name: user.get('name'),
        id: user.id
      },
      added: new Structural.Collections.Participants(added).toJSON(),
      removed: new Structural.Collections.Participants(removed).toJSON()
    });
  },
  createMessageAction: function(text, user) {
    this._newAction({
      type: 'message',
      text: text,
      user: {
        name: user.get('name'),
        id: user.id
      },
      timestamp: Date.now()
    });
  },
  createDeleteAction: function(action, user) {
    var model = new Structural.Models.Action({
      type: 'deletion',
      msg_id: action.id,
      user: {
        name: user.get('name'),
        id: user.id
      }
    });
    model.url = this.url();
    model.save();
    action.delete(user);
  },
  createMoveConversationAction: function(topic, user) {
    this._newAction({
      type: 'move_conversation',
      user: {
        name: user.get('name'),
        id: user.id
      },
      conversation_id: this.conversationId,
      to: {
        name: topic.get('name'),
        id: topic.id
      }
    });
  },

  changeConversation: function(id) {
    this.conversationId = id;
    this.fetch({reset: true});
  },

  calculateUnreadedness: function(participants) {
    if (participants) {
      this.cachedParticipants = participants;
    }
    else if (this.cachedParticipants) {
      participants = this.cachedParticipants;
    }
    else {
      return;
    }

    var me = participants.where({id: this.userId})[0];
    if (!me) { return; }

    var cutoff = me.get('most_recent_viewed');
    this.filter(function(action) {
      return action.get('timestamp') > cutoff;
    }).forEach(function(action) {
      action.markUnread();
    });
  },

  _newAction: function(data) {
    var model = new Structural.Models.Action(data);
    this.add(model);
    model.save();
  }
});
