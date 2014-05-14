Structural.Views.WaterCooler = Support.CompositeView.extend({
  className: 'water-cooler',
  initialize: function(options) {
    options = options || {};
    this.folders = options.folders;
    this.conversations = options.conversations;
    this.actions = options.actions;
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.user = options.user;
    this.listenTo(Structural,'showResponsiveActions',this.showAct);
    this.listenTo(Structural,'showResponsiveConversations',this.showCnv);
  },
  events: {
    'click .act-container .ui-back-button': 'showCnv',
    'click .cnv-container .ui-back-button': 'showFld',
    'click .fld-popover-close-button':'showCnv'
  },
  render: function() {
    this.foldersView = new Structural.Views.FolderContainer({
      folders: this.folders,
      user: this.user
    });
    this.conversationsView = new Structural.Views.ConversationContainer({
      conversations: this.conversations,
      user: this.user
    });
    this.actionsView = new Structural.Views.ActionContainer({
      actions: this.actions,
      conversation: this.conversation,
      participants: this.participants,
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
  },

  showAct: function(e){
    if (e) { e.preventDefault(); }

    this.actionsView.show(true);
    this.conversationsView.show(false);
    this.foldersView.show(false);
    this.$el.removeClass('hidden');
  },
  showCnv: function(e){
    if (e) { e.preventDefault(); }
    this.foldersView.show(false);
    this.conversationsView.show(true);
    this.actionsView.show(false);
    this.$el.removeClass('hidden');
  },
  showFld: function(e){
    if (e) { e.preventDefault(); }

    this.foldersView.show(true);
    this.conversationsView.show(false);
    this.actionsView.show(false);
    this.$el.removeClass('hidden');
  },
  showStb: function(e){
    if (e) { e.preventDefault(); }

    this.foldersView.show(false);
    this.conversationsView.show(false);
    this.actionsView.show(false);
    this.$el.addClass('hidden');
  }
});
