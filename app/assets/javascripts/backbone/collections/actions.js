Structural.Collections.Actions = Backbone.Collection.extend({
  model: Structural.Models.Action,
  url: function() {
    return Structural.apiPrefix + '/conversations/' + this.conversation.id + '/actions';
  },
  initialize: function(data, options) {
    options = options || {};
    this.conversation = options.conversation;
    this.userId = options.user;
    this.loadingActions = false;
    this.on('reset', this._findMyMessages, this);
    this.on('reset', this._findFocusedMessage, this);
    this.on('reset', this._findFollowOnMessages, this);
    this.on('reset', this._findUnreadMessages, this);
    this.on('add', this.setStateOnNewAction, this);
    this.on('add', function(model, collection, options) {
      this.trigger('unreadCountChanged');
    });
    this.on('add', this.triggerNewMessage, this);
    this.on('sort', this._findFollowOnMessages, this);
    this.on('sync', function() {
      this.loadingActions = false;
      this.trigger('doneLoading');
    }, this);
  },
  comparator: 'timestamp',

  _findMyMessages: function() {
    this.forEach(function(action) {
      if (action.get('user').id === this.userId) {
        action.mine();
      }
    }, this);
  },

  _findFocusedMessage: function() {
    if (this._idToFocus) {
      var action = this.get(this._idToFocus);
      if (action) {
        action.focus();
      }
    }
  },

  _findFollowOnMessages: function() {
    this.forEach(function(action, index) {
      if (index > 0) {
        var previous = this.at(index - 1);
        if (action.isFollowOn(previous)) {
          action.followOn();

          if (action.isInDifferentTimeBucket(previous)) {
            action.followOnLongTerm();
          }
        }
      }
    }, this);
  },

  _findUnreadMessages: function() {
    this.filter(function(action) {
      return action.isUnread(this.conversation.get('most_recent_viewed'));
    }, this).forEach(function(action) {
      action.markUnread();
    });
  },

  focus: function(id) {
    id = parseInt(id);
    var action = this.get(id);
    if(action) {
      action.focus();
    } else {
      this._idToFocus = id;
    }

    this.filter(function(act) { return act.isFocused() && act.id != id; })
        .forEach(function(act) {
      act.unfocus();
    });
  },

  markReadUpTo: function(action) {
    this.conversation.updateMostRecentViewedTo(action.get('timestamp'));
  },

  clearFocus: function() {
    this._idToFocus = undefined;
    this.forEach(function(act) {
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
    var model = this._newAction({
      type: 'message',
      text: text.trim(),
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
  createMoveConversationAction: function(folder, user) {
    this._newAction({
      type: 'move_conversation',
      user: {
        name: user.get('name'),
        id: user.id
      },
      conversation_id: this.conversation.id,
      to: {
        name: folder.get('name'),
        id: folder.id
      }
    });
  },
  createUpdateFoldersAction: function(added, removed, user) {
    this._newAction({
      type: 'update_folders',
      user: {
        name: user.get('name'),
        id: user.id
      },
      added: new Structural.Collections.Folders(added).toJSON(),
      removed: new Structural.Collections.Folders(removed).toJSON()
    });
  },

  // This actions collection's conversation is being viewed.
  viewActions: function() {
    var self = this;
    var options = {}
    if (this.length === 0) {
      options.reset = true;

      // We want to let our views know that they can go ahead and render the actions en block now,
      // since they're actually loaded.
      options.success = function() {
        self.trigger('actionsLoadedForFirstTime');
      }
    }
    this.loadingActions = true;
    this.fetch(options);
  },

  // TODO: Remove & remove references to it.
  clearConversation: function() {},

  setStateOnNewAction: function(model, collection) {
    if (model.get('user').id === this.userId) {
      model.mine();
    }

    var index = collection.indexOf(model);
    if (index > 0) {
      var previous = collection.at(index - 1);
      if (model.isFollowOn(previous)) {
        model.followOn();

        if (model.isInDifferentTimeBucket(previous)) {
          model.followOnLongTerm();
        }
      }
    }

    if (model.isUnread(this.conversation.get('most_recent_viewed'))) {
      model.markUnread();
    }
  },
  triggerNewMessage: function(model) {
    if (model.isMessageType() &&
        model.get('user').id !== this.userId) {
      this.trigger('addedSomeoneElsesMessage')
    }
  },

  _newAction: function(data) {
    var model = new Structural.Models.Action(data);
    model.set('timestamp', (new Date()).valueOf());
    this.add(model);
    model.save();
    return model;
  },

  unreadCount: function(mostRecentEventViewed) {
    var count = 0;
    this.forEach(function(action) {
      if (action.isMessageType()) {
        count += action.isUnread(mostRecentEventViewed) ? 1 : 0;
      }
    });
    return count;
  },

  /* A follow on group consists of an action followed by zero or more actions
     that have 'followOn' set to true. */
  findFollowOnGroup: function(action) {
    var group = [action];
    var index = this.indexOf(action);
    if (action.get('followOn')) {
      for (var i = index - 1; i >= 0; i--) {
        var act = this.at(i);
        group.splice(0, 0, act);
        if (!act.get('followOn')) {
          break;
        }
      }
    }

    for (var i = index + 1; i < this.length; i++) {
      var act = this.at(i);
      if (act.get('followOn')) {
        group.push(act);
      } else {
        break;
      }
    }

    return group;
  },

  fetch: function(options) {
    if (this.conversation.id) {
      // http://rockycode.com/blog/backbone-inheritance/
      // God, I fucking hate javascript so much.  Is this really the best there
      // is for basic inheritance?  Should we be using mixins instead?
      return this.constructor.__super__.fetch.call(this, options);
    }
  }
});
