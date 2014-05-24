// A view for the actual conversations list.

Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list ui-scrollable',
  emptyTemplate: JST.template('conversations/empty_collection'),
  loadingTemplate: JST.template('conversations/loading_collection'),
  initialize: function(options) {
    options = options || {};
    this.user = options.user;
    this._loadingConversations = false;

    this._wireEvents(this.collection);
    Structural.on('changeFolder', this.changeFolder, this);

    // The viewOrder property is the order that sections show up in the DOM,
    // the priority property controls the order that we check the section
    // predicates.  The first section (in priority order) whose predicate is
    // true for a conversation is the section we put that convo in.
    this.sections = [
      new Structural.Views.ConversationsSection({
        name: 'My Conversations',
        user: this.user,
        viewOrder: 2,
        priority: 4,
        predicate: function(conversation) {
          return true;
        }
      }),
      new Structural.Views.ConversationsSection({
        name: 'Archive',
        adjective: 'Archived',
        startsCollapsed: true,
        user: this.user,
        viewOrder: 4,
        priority: 2,
        predicate: function(conversation) {
          return conversation.get('archived');
        }
      }),
      new Structural.Views.ConversationsSection({
        name: 'Shared Conversations',
        adjective: 'Shared',
        user: this.user,
        viewOrder: 3,
        priority: 3,
        predicate: function(conversation) {
          var participantIds = conversation.get('participants')
                                           .map(function(p) { return p.id; });
          // The 'this' reference here is actually the conversation section,
          // which also has a user property.
          return !_.contains(participantIds, this.user.id);
        }
      }),
      new Structural.Views.ConversationsSection({
        name: 'Pinned Conversations',
        adjective: 'Pinned',
        user: this.user,
        viewOrder: 1,
        priority: 1,
        predicate: function(conversation) {
          return conversation.get('pinned');
        }
      })
    ];
  },
  _wireEvents: function(collection) {
    collection.on('add', this.reRender, this);
    collection.on('reset', this.reRender, this);
    collection.on('remove', this.reRender, this);
    collection.on('conversationsLoadedForFirstTime', this.viewTargetOrFirstConversation, this);
    collection.on('archived', this.reRender, this);
    collection.on('pinned', this.reRender, this);
    collection.on('focus:conversation', this.showFocusedConversation, this);
    collection.on('sync', this._noLongerLoading, this);
  },
  render: function() {
    this.$el.empty();

    _.forEach(this.sections, function(section) {
      section.collection = [];
    });

    if (this._loadingConversations) {
      this.$el.html(this.loadingTemplate());
    } else if (this.collection.length == 0) {
      this.$el.html(this.emptyTemplate());
    } else {
      this.renderConversations();
    }
    return this;
  },
  renderConversations: function() {
    this.collection.forEach(function(conversation) {
      var section = this.sectionForConversation(conversation);
      section.collection.push(conversation);
    }, this);

    var sortedSections = _.sortBy(this.sections, 'viewOrder');
    _.each(sortedSections, this.renderSection, this);

    return this;
  },
  renderSection: function(section) {
    if (section.collection.length > 0) {
      this.appendChild(section);
    }
  },
  reRender: function() {
    this.children.forEach(function(child) {
      child.leave();
    });
    this.render();
  },

  sectionForConversation: function(conversation) {
    var sortedSections = _.sortBy(this.sections, 'priority');
    return _.find(sortedSections, function(section) {
      return section.predicate(conversation);
    });
  },

  changeFolder: function(folder) {
    this._loadingConversations = true;

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
  },

  showFocusedConversation: function(conversation) {
    var section = this.sectionForConversation(conversation);
    if (section.isCollapsed()) {
      section.toggleCollapsed();
    }

    var focusedView = section.getFocusedView(conversation);
    if (focusedView) {
      this.scrollToTargetAtEarliestOpportunity(focusedView);
    }
  },

  _noLongerLoading: function() {
    this._loadingConversations = false;
    this.reRender();
  }
});

_.extend(Structural.Views.Conversations.prototype, Support.Scroller);
