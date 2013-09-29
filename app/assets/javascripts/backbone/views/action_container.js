Structural.Views.ActionContainer = Support.CompositeView.extend({
  className: function() {
    var classes = 'act-container';

    if (this.participants &&
        !_(this.participants.map(function(p) { return p.id; })).contains(this.user.id)) {
      classes += ' not-participating-in';
    }

    return classes;
  },
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.actions = options.actions;
    this.addressBook = options.addressBook;
    this.user = options.user;
    this.folders = options.folders;

    this.participants.on('reset', this.reClass, this);

    Structural.on('changeConversation', this.changeConversation, this);
  },
  render: function() {
    this.titleView = new Structural.Views.TitleEditor({
      conversation: this.conversation,
      folders: this.folders
    });
    this.participantsView = new Structural.Views.ParticipantEditor({
      participants: this.participants,
      addressBook: this.addressBook
    });
    this.actionsView = new Structural.Views.Actions({collection: this.actions});
    this.composeView = new Structural.Views.Compose({conversation: this.conversation});

    this.appendChild(this.titleView);
    this.appendChild(this.participantsView);
    this.appendChild(this.actionsView);
    this.appendChild(this.composeView);

    this.titleView.on('change_title', Structural.createRetitleAction, Structural);
    this.participantsView.on('update_users', Structural.createUpdateUserAction, Structural);

    // The first time backbone calls className we don't have some data?
    this.reClass();

    return this;
  },

  // TODO: Seems a little funky that we're holding onto so much information about our
  // current coversation, but c'est la vie.
  changeConversation: function(conversation) {
    this.participants.off(null, null, this);
    this.conversation = conversation;
    this.participants = conversation.get('participants');
    this.reClass();
  },
  clearConversation: function() {
    this.titleView.clearConversation();
    this.composeView.clearConversation();
  },
  scrollToBottom: function() {
    this.actionsView.scrollToBottom();
  },
  isAtBottom: function() {
    return this.actionsView.isAtBottom();
  },

  reClass: function() {
    this.el.className = this.className();
  }
});
