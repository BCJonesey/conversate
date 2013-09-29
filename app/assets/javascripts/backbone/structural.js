#= require ./support/support
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

var Structural = new (Support.CompositeView.extend({
  Models: {},
  Collections: {},
  Views: {},
  Router: {},

  initialize: function(options) {
    this.apiPrefix = options.apiPrefix;
  },
  start: function(bootstrap) {

    // Instantiate our primary data structures from our bootstrap data.
    // We only care about things that are convenient to directly access right now,
    // like the current folders, the current folder, the current conversation,
    // and the current user.
    this._user = new Structural.Models.User(bootstrap.user);
    this._folders = new Structural.Collections.Folders(bootstrap.folders, {
      // This is the only Folders collection that we want to handle events.
      isMainCollection: true
    });

    // We pass the folder over, but we should let it come from the collection.
    this._folder = this._folders.where({id: bootstrap.folder.id})[0];
    this._folder.conversations.set(bootstrap.conversations);

    // Instantiate the current conversation or a sane default.
    this._conversation =  this._folder.conversations.where({id: bootstrap.conversation.id})[0];
    this._conversation = this._conversation ? this._conversation : new Structural.Models.Conversation();

    // Setup our current conversation's actions from the bootstrap data.
    if (this._conversation && this._conversation.id) {
      this._conversation.set('is_current', true);
      this._conversation.actions.set(bootstrap.actions);
      this._conversation.actions._findMyMessages();
    }

    // TODO: Refactor to be like other things instead of a singleton collection.
    this._participants = new Structural.Collections.Participants(
      bootstrap.participants,
      // TODO: Is this even necessary now?
      {conversation: this._conversation ? this._conversation.id : undefined}
    );

    // Setup our views with appropriate data settings.
    this._bar = new Structural.Views.StructuralBar({model: this._user});
    this._watercooler = new Structural.Views.WaterCooler({
      folders: this._folders,
      conversations: this._folder.conversations,
      actions: this._conversation.actions,
      participants: this._participants,
      conversation: this._conversation,
      addressBook: this._user.get('address_book'),
      user: this._user
    });
    this._faviconAndTitle = new Structural.Views.FaviconAndTitle({
      folders: this._folders
    });

    this.appendChild(this._bar);
    this.appendChild(this._watercooler);
    this._faviconAndTitle.render();

    Backbone.history.start({pushState: true});

    // Turn on our fetchers.
    this.actionsFetcher = new Support.ActionsFetcher(this._conversation, 5000);
    this.folderFetcher = new Support.ConversationsFetcher(this._folder.conversations, 60000);
    this.foldersFetcher = new Support.FoldersFetcher(this._folders, 60000);

    // Focus initial folder.
    this._folders.focus(this._folder.id);
    this._folders.focusAlternates(this._conversation);

    return this;
  },

  events: {
    'click': 'clickAnywhere'
  },
  clickAnywhere: function(e) {
    this.trigger('clickAnywhere', e);
  },

  // TODO: Focus is a little funky. We can probably shift this to
  // the appropriate view functions. Folders was pulled out for performance
  // reasons when switching conversations.
  focus: function(targets) {
    if (targets.conversation) {
      this._folder.conversations.focus(targets.conversation);
    }

    if (targets.message) {
      this._conversation.actions.focus(targets.message);
    }
  },

  moveConversationMode: function() {
    this._watercooler.moveConversationMode();
  },
  newConversationMode: function() {
    var view = new Structural.Views.NewConversation({
      addressBook: this._user.get('address_book')
    });
    this.appendChild(view);
  },

  viewConversationData: function(conversation) {
    if (!this._conversation || conversation.id !== this._conversation.id) {
      this._conversation = conversation;
      this.trigger('changeConversation', conversation);
    }
  },
  // Show a specific conversation.
  viewConversation: function(conversation) {
    // Let's not bother swapping if this is already the current conversation.
    if (!this._conversation || conversation.id !== this._conversation.id) {
      this.viewConversationData(conversation);
      Structural.Router.navigate(Structural.Router.conversationPath(conversation),
                               {trigger: true});
    }
  },
  clearConversation: function() {
    this.trigger('clearConversation');
    this._conversation = null;
  },

  // Show the first conversation in a specific folder, if able.
  viewFolder: function(folder) {
    var self = this;
    if (folder.id !== this._folder.id) {
      this._folder = folder;

      // TODO: Refactor focus in general.
      this._folders.focus(folder.id);

      // We need to clear out our conversation view because we're about to swap.
      self.clearConversation();

      this.trigger('changeFolder', folder);
      Structural.Router.navigate(Structural.Router.folderPath(folder),
                                 {trigger: true});
    }
  },
  createRetitleAction: function(title) {
    this._conversation.actions.createRetitleAction(title, this._user);
  },
  createUpdateUserAction: function(added, removed) {
    this._conversation.actions.createUpdateUserAction(added, removed, this._user);
  },
  createMessageAction: function(text) {
    this._conversation.actions.createMessageAction(text, this._user);

    // A user sending a message should definitely update this time.
    this._conversation.updateMostRecentViewedToNow();

    this._watercooler.scrollActionsToBottom();
  },
  createDeleteAction: function(action) {
    this._conversation.actions.createDeleteAction(action, this._user);
  },
  createUpdateFoldersAction: function(added, removed) {
    this._conversation.actions.createUpdateFoldersAction(added, removed, this._user);
    this._folders.updateConversationLists(this._conversation, added, removed);
    this._conversation.updateFolderIds(added, removed);
  },
  createNewConversation: function(title, participants, message) {
    var data = {};
    data.title = title;
    data.participants = participants.map(function(p) {
      return {
        id: p.id,
        name: p.get('name')
      }
    });
    if (message.length > 0) {
      data.actions = [
        { type: 'message',
          user: { id: this._user.id },
          text: message
        }
      ]
    }
    data.most_recent_event = (new Date()).valueOf();

    var conversation = new Structural.Models.Conversation(data);
    conversation.get('participants').add([this._user], {at: 0});
    this._folder.conversations.add(conversation);
    conversation.save(null, {
      success: function (conversation, response) {
        // Need to tell our actions collection our server-approved new id.
        // TODO: Right place for this? Maybe hide behind a function?
        conversation.actions.conversationId = conversation.id;

        conversation.focus();
        Structural.viewConversation(conversation);
      }
    });
  },
  moveConversation: function(folder) {
    this._conversation.actions.createMoveConversationAction(folder, this._user);
    this.viewFolder(this._folders.current());
  },
  updateTitleAndFavicon: function() {
    if (this._faviconAndTitle) {
      this._faviconAndTitle.render();
    }
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
