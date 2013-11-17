Structural.Views.Action = Support.CompositeView.extend({
  className: function() {
    var classes = 'act btn-faint-container';
    classes += ' act-' + this.model.get('type').replace('_', '-');
    if (this.model.get('isOwnAction')) {
      classes += ' act-my-message';
    }
    if(this.model.get('is_current')) {
      classes += ' act-current';
    }
    if(this.model.get('is_unread')) {
      classes += ' act-unread';
    }
    if(this.model.isUpdateFoldersWithoutAdditions()) {
      classes += ' hidden';
    }
    return classes;
  },

  messageTemplate: JST['backbone/templates/actions/message'],
  emailMessageTemplate: JST['backbone/templates/actions/email_message'],
  updateUsersTemplate: JST['backbone/templates/actions/update_users'],
  updateViewersTemplate: JST['backbone/templates/actions/update_viewers'],
  retitleTemplate: JST['backbone/templates/actions/retitle'],
  deletionTemplate: JST['backbone/templates/actions/deletion'],
  moveConversationTemplate: JST['backbone/templates/actions/move_conversation'],
  moveMessageTemplate: JST['backbone/templates/actions/move_message'],
  updateFoldersTemplate: JST['backbone/templates/actions/update_folders_action'],

  initialize: function(options) {
    this.model.on('change', function() {
      this.reRender();
      // TODO: If we just set is_current to true, we want to scroll to the message.
    }, this);

    // If a model gets dumped, like when we try to post while getting actions, this will
    // clean up the duped view.
    this.model.on('remove', function() {
      this.leave();
    }, this)
  },
  render: function() {
    var template;
    switch(this.model.get('type')) {
      case 'message':
        template = this.messageTemplate;
        break;
      case 'email_message':
        template = this.emailMessageTemplate;
        break;
      case 'update_users':
        template = this.updateUsersTemplate;
        break;
      case 'update_viewers':
        template = this.updateViewersTemplate;
        break;
      case 'retitle':
        template = this.retitleTemplate;
        break;
      case 'deletion':
        template = this.deletionTemplate;
        break;
      case 'move_message':
        template = this.moveMessageTemplate;
        break;
      case 'move_conversation':
        template = this.moveConversationTemplate;
        break;
      case 'update_folders':
        template = this.updateFoldersTemplate;
        break;
    }
    this.$el.html(template({action: this.model}));
    return this;
  },
  reClass: function() {
    this.el.className = this.className();
  },
  reRender: function() {
    this.reClass();
    this.render();
  },
  events: {
    'click .act-delete': 'deleteMessage',
    'mouseover': 'markRead'
  },
  deleteMessage: function(e) {
    e.preventDefault();
    Structural.createDeleteAction(this.model);
  }
});
