Structural.Views.WaterCooler = Support.CompositeView.extend({
  className: 'water-cooler',
  initialize: function(options) {
    options = options || {};
    this.folders = options.folders;
    this.conversations = options.conversations;
    this.actions = options.actions;
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.addressBook = options.addressBook;
    this.user = options.user;
  },
  render: function() {
    this.foldersView = new Structural.Views.FolderContainer({
      folders: this.folders,
      addressBook: this.addressBook
    });
    this.conversationsView = new Structural.Views.ConversationContainer({
      conversations: this.conversations,
      user: this.user
    });
    this.actionsView = new Structural.Views.ActionContainer({
      actions: this.actions,
      conversation: this.conversation,
      participants: this.participants,
      addressBook: this.addressBook,
      user: this.user,
      folders: this.folders
    });

    this.appendChild(this.foldersView);
    this.appendChild(this.conversationsView);
    this.appendChild(this.actionsView);
  },

  changeConversation: function(conversation) {
    this.actionsView.changeConversation(conversation);
  },
  clearConversation: function() {
    this.actionsView.clearConversation();
  },
  moveConversationMode: function() {
    this.foldersView.moveConversationMode();
  },
  scrollActionsToBottom: function() {
    this.actionsView.scrollToBottom();
  }
});
