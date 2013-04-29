Structural.Views.ActionContainer = Support.CompositeView.extend({
  className: 'act-container',
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.actions = options.actions;
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.titleView = new Structural.Views.TitleEditor({conversation: this.conversation});
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

    return this;
  },

  changeConversation: function(conversation) {
    this.titleView.changeConversation(conversation);
    this.composeView.changeConversation(conversation);
  }
});
