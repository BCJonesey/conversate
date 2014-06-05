//= require_tree ./monkeypatches
//= require ./support/support
//= require_self
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
//= require_tree ./components

var Structural = new (Support.CompositeView.extend({
  Models: {},
  Collections: {},
  Views: {},
  Router: {},
  Components: {},

  initialize: function(options) {
    this.apiPrefix = options.apiPrefix;
  },
  start: function(bootstrap) {

    // Instantiate our primary data structures from our bootstrap data.
    // We only care about things that are convenient to directly access right now,
    // like the current folders, the current folder, the current conversation,
    // and the current user.
    this._user = new Structural.Models.User(bootstrap.user);
    this._contactLists = new Structural.Collections.ContactLists();
    this._contactLists.fetch({success: function(){Structural._user.rebuildAddressBook();}});
    this._folders = new Structural.Collections.Folders(bootstrap.folders, {
      // This is the only Folders collection that we want to handle events.
      isMainCollection: true
    });

    // We do not bootstrap the "people" information so this value will start at null
    this._selectedContactListId = null;

    // We pass the folder over, but we should let it come from the collection.
    this._folder = this._folders.where({id: bootstrap.folder.id})[0];
    this._folder.conversations.set(bootstrap.conversations);


    // Instantiate the current conversation or a sane default.
    this._conversation = this._folder.conversations.where({id: bootstrap.conversation.id})[0];
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
    this._people = new Structural.Views.People();
    this._watercooler = new Structural.Views.WaterCooler({
      folders: this._folders,
      conversations: this._folder.conversations,
      actions: this._conversation.actions,
      participants: this._participants,
      conversation: this._conversation,
      user: this._user
    });
    this._faviconAndTitle = new Structural.Views.FaviconAndTitle({
      folders: this._folders
    });

    Structural.Toaster = new Structural.Components.Toaster();
    Structural.FileUploadToaster = new Structural.Components.FileUploadToaster();

    this.appendChild(Structural.Toaster.view);
    this.appendChild(Structural.FileUploadToaster.view);
    this.appendChild(this._bar);
    this.appendChild(this._watercooler);
    //this.appendChild(this._people);
    this._faviconAndTitle.render();

    Backbone.history.start({pushState: true});

    // Turn on our fetchers.
    this.actionsFetcher = new Support.ActionsFetcher(this._conversation.actions);
    this.folderFetcher = new Support.ConversationsFetcher(this._folder.conversations);
    this.foldersFetcher = new Support.FoldersFetcher(this._folders);
    this.contactsFetcher = new Support.ContactsFetcher(this._contactLists);

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

    if (targets.action) {
      this._conversation.actions.focus(targets.action);
    }
  },

  moveConversationMode: function() {
    this._watercooler.moveConversationMode();
  },
  newConversationMode: function() {
    var view = new Structural.Views.NewConversation();
    this.appendChild(view);
  },

  viewConversationData: function(conversation, options) {
    options = _.defaults(options || {}, {silentResponsiveView: false});

    if (!this._conversation || conversation.id !== this._conversation.id) {
      this._conversation = conversation;

      this.trigger('changeConversation', conversation);

      if (this._actionToViewAfterViewingConversation) {
        Structural.Router.navigate(
          Structural.Router.actionPath(
            this._conversation,
            this._actionToViewAfterViewingConversation),
          { trigger: true });
        this._actionToViewAfterViewingConversation = undefined;
      }
    }

    if (!options.silentResponsiveView) {
      this.trigger('showResponsiveActions');
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

    this.trigger('showResponsiveActions');
  },
  viewAction: function(conversation, action) {
    var targetFolderId = Structural.Router._folderIdForConversation(conversation);
    if (this._folder.id !== targetFolderId) {
      var targetFolder = this._folders.get(targetFolderId);
      this.viewFolder(targetFolder, conversation);
      this._actionToViewAfterViewingConversation = action;
    } else if (this._conversation.id !== conversation.id) {
      var targetConversation = this._folder.conversations.get(conversation.id);
      this.viewConversationData(targetConversation);
      Structural.Router.navigate(
        Structural.Router.actionPath(conversation, action),
        { trigger: true });
    }

    this.trigger('showResponsiveActions');
  },
  clearConversation: function() {
    this.trigger('clearConversation');
    this._conversation = null;
  },

  // Show the target conversation or first in a specific folder, if able.
  viewFolder: function(folder, targetConversation) {
    var self = this;
    if (folder.id !== this._folder.id) {
      this._folder = folder;

      // TODO: Refactor focus in general.
      this._folders.focus(folder.id);

      // We need to clear out our conversation view because we're about to swap.
      self.clearConversation();

      this.conversationToShowAfterFolderChange = targetConversation;
      this.trigger('changeFolder', folder);
      Structural.Router.navigate(Structural.Router.folderPath(folder),
                               {trigger: true});
    }

    this.trigger('showResponsiveConversations');
  },
  deleteFolder: function(folder) {
    this._folders.remove(folder);
    folder.destroy();
    this.viewFolder(Structural._folders.at(0));
  },
  createNewFolder: function () {
    this._folders.createNewFolder('New Folder');
  },
  createRetitleAction: function(title) {
    this._conversation.actions.createRetitleAction(title, this._user);
  },
  createUpdateUserAction: function(added, removed) {
    this._conversation.actions.createUpdateUserAction(added, removed, this._user);
  },
  addSelfToConversation: function(){
    var convo = this._conversation;
    convo.actions.createUpdateUserAction([this._user], [], this._user);
    Structural._conversation.get("participants").add(new Structural.Models.Participant(Structural._user.attributes))
    this._folder.conversations.fetch(true);
    this.trigger('changeConversation', convo);
  },
  removeSelfFromConversation: function() {
    var participant = new Structural.Models.Participant(this._user.attributes);
    this._conversation.get('participants').remove(participant);
    this.trigger('changeConversation', this._conversation);
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
  },
  showPeople: function(){
    this._watercooler.leave();
    this._people = new Structural.Views.People();
    this.appendChild(this._people);
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
