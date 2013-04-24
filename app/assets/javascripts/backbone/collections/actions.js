Structural.Collections.Actions = Backbone.Collection.extend({
  model: Structural.Models.Action,
  url: function() {
    return Structural.apiPrefix + '/conversations/' + this.conversationId + '/actions';
  },
  initialize: function(data, options) {
    options = options || {};
    this.conversationId = options.conversation;
  },
  comparator: 'timestamp',

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

  _newAction: function(data) {
    var model = new Structural.Models.Action(data);
    this.add(model);
    model.save();
  }
});
