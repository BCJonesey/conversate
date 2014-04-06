Structural.Views.Action = Support.CompositeView.extend({
  className: function() {
    var classes = 'act btn-faint-container';

    if (this.model.get('type') == 'message' ||
        this.model.get('type') == 'email_message' ||
        this.model.get('type') == 'upload_message') {
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

    if (this.model.get('focused')) {
      classes += ' act-current';
    }

    if (this.model.get('followOn')) {
      classes += ' act-follow-on';
    }

    if (this.model.get('followOnLongTerm')) {
      classes += ' act-follow-on-long-term';
    }

    return classes;
  },

  templates: {
    'message': JST.template('actions/message'),
    'email_message': JST.template('actions/email_message'),
    'upload_message': JST.template('actions/upload_message'),
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
    // In our current architecture there's no reason for an action to ever change,
    // so we don't need to do this.  In the future there may be a reason for
    // models to change, like if they get deleted or edited.  If that's the case
    // you should solve the problem of firing change events on every model on
    // every poll that happens when backbone tries to compare our inflated
    // attributes.
    // this.model.on('change', function() {
    //   this.reRender();
    // }, this);

    // If a model gets dumped, like when we try to post while getting actions, this will
    // clean up the duped view.
    this.model.on('remove', function() {
      this.leave();
    }, this);

    this.model.on('change:focused change:is_unread', function() {
      if (this.model.get('focused')) {
        this.model.collection.trigger('focusedView', this);
      }
      this.reClass();
    }, this);
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
    'click .act-show-full-text': 'showFullText',
    'click': 'markRead'
  },
  deleteMessage: function(e) {
    e.preventDefault();
    Structural.createDeleteAction(this.model);
  },
  showFullText: function(e) {
    e.preventDefault();
    this.model.collection.trigger('showDetails', this.model);
  },
  focused: function() {
    return this.model.get('focused');
  },
  markRead: function() {
    if (this.model.get('is_unread')) {
      this.model.collection.markReadUpTo(this.model);
    }
  }
});
