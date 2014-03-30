// A view for the actual conversations list.

Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list ui-scrollable',
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this._wireEvents(this.collection);

    Structural.on('changeFolder', this.changeFolder, this);

    this.sectionRegular = new Structural.Views.ConversationsSection({
      name: "My Conversations",
      user: this.user
    });
    this.sectionArchived = new Structural.Views.ConversationsSection({
      name: "Archive",
      user: this.user,
      startsCollapsed: true
    });
  },
  _wireEvents: function(collection) {
    collection.on('add', this.reRender, this);
    collection.on('reset', this.reRender, this);
    collection.on('remove', this.reRender, this);
    collection.on('conversationsLoadedForFirstTime', this.viewTargetOrFirstConversation, this);
    collection.on('archived', this.reRender, this);
  },
  render: function() {
    this.$el.empty();

    // TODO: We can almost certainly make this much more generic for n sections.

    var regularConversations = [];
    var archivedConversations = [];

    this.collection.forEach(function(conversation) {
      if (conversation.get('archived')) {
        archivedConversations.push(conversation);
      } else {
        regularConversations.push(conversation);
      }
    }, this);

    // We only want to show a section if there are actually archived conversations.

    if (regularConversations.length > 0) {
      this.sectionRegular.collection = regularConversations;
      this.appendChild(this.sectionRegular);
    }

    if (archivedConversations.length > 0) {
      this.sectionArchived.collection = archivedConversations;
      this.appendChild(this.sectionArchived);
    }

    return this;
  },
  reRender: function() {
    this.children.forEach(function(child) {
      child.leave();
    });
    this.render();
  },
  changeFolder: function(folder) {
    this.collection.off(null, null, this);
    this.collection = folder.conversations;
    this._wireEvents(this.collection);

    // Attempt to show the first conversation. This gets called always, so will
    // pick up on cached conversations just fine. However, the
    // conversationsLoadedForFirstTime event will pick up on conversations that
    // needed fetching for picking the first.
    this.viewTargetOrFirstConversation();

    this.reRender();
  },

  // Attempts to show Structural's target conversation, if it exists and is
  // in the folder we just switched to.  If either of those are false, attempt
  // to show the first conversation in the folder. This basically gets called
  // after the conversations have finished loading, so we can actually pick one
  /// to show. We don't want to pick one that has been archived.
  viewTargetOrFirstConversation: function() {
    var conversation;
    if (Structural.conversationToShowAfterFolderChange) {
      conversation = this.collection.get(
        Structural.conversationToShowAfterFolderChange.id);
      if (conversation) {
        Structural.conversationToShowAfterFolderChange = undefined;
      }
    }

    if (!conversation) {
      conversation = this.collection.findWhere({archived: false});
    }

    if (conversation) {
      Structural.viewConversationData(conversation,
                                      {silentResponsiveView: true});
      conversation.focus();
    }
  }
});

