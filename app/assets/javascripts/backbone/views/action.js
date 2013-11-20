Structural.Views.Action = Support.CompositeView.extend({
  className: function() {
    var classes = 'act btn-faint-container';

    if (this.model.get('type') == 'message' ||
        this.model.get('type') == 'email_message') {
      classes += ' act-msg';
    } else {
      classes += ' act-sys';
    }
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
      classes += ' removed';
    }

    return classes;
  },

  templates: {
    'message': JST.template('actions/message'),
    'email_message': JST.template('actions/email_message'),
    'update_users': JST.template('actions/update_users'),
    'update_viewers': JST.template('actions/update_viewers'),
    'retitle': JST.template('actions/retitle'),
    'deletion': JST.template('actions/deletion'),
    'move_message': JST.template('actions/move_message'),
    'move_conversation': JST.template('actions/move_conversation'),
    'update_folders': JST.template('actions/update_folders_action'),
    'email_delivery_error': JST.template('actions/email_delivery_error')
  },

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
    var template = this.templates[this.model.get('type')];
    // TODO: make a default template or something

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
