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
    // like the current topics, the current topic, the current conversation,
    // and the current user.
    this._user = new Structural.Models.User(bootstrap.user);
    this._topics = new Structural.Collections.Topics(bootstrap.topics, {
      isMainCollection: true
    });

    // We pass the topic over, but we should let it come from the collection.
    this._topic = this._topics.where({id: bootstrap.topic.id})[0];
    this._topic.conversations.set(bootstrap.conversations);

    // Instantiate the current conversation or a sane default.
    this._conversation =  this._topic.conversations.where({id: bootstrap.conversation.id})[0];
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
      topics: this._topics,
      conversations: this._topic.conversations,
      actions: this._conversation.actions,
      participants: this._participants,
      conversation: this._conversation,
      addressBook: this._user.get('address_book'),
      user: this._user
    });
    this._faviconAndTitle = new Structural.Views.FaviconAndTitle({
      topics: this._topics
    });

    this.appendChild(this._bar);
    this.appendChild(this._watercooler);
    this._faviconAndTitle.render();

    Backbone.history.start({pushState: true});

    // Turn on our fetchers.
    this.actionsFetcher = new Support.ActionsFetcher(this._conversation, 5000);
    this.topicFetcher = new Support.ConversationsFetcher(this._topic.conversations, 60000);
    this.topicsFetcher = new Support.TopicsFetcher(this._topics, 60000);

    // Focus initial topic.
    this._topics.focus(this._topic.id);
    this._topics.focusAlternates(this._conversation);

    return this;
  },

  events: {
    'click': 'clickAnywhere'
  },
  clickAnywhere: function(e) {
    this.trigger('clickAnywhere', e);
  },

  // TODO: Focus is a little funky. We can probably shift this to
  // the appropriate view functions. Topics was pulled out for performance
  // reasons when switching conversations.
  focus: function(targets) {
    if (targets.conversation) {
      this._topic.conversations.focus(targets.conversation);
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

  // Show the first conversation in a specific topic, if able.
  viewTopic: function(topic) {
    var self = this;
    if (topic.id !== this._topic.id) {
      this._topic = topic;

      // TODO: Refactor focus in general.
      this._topics.focus(topic.id);

      // We need to clear out our conversation view because we're about to swap.
      self.clearConversation();

      this.trigger('changeTopic', topic);
      Structural.Router.navigate(Structural.Router.topicPath(topic),
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
  createUpdateTopicsAction: function(added, removed) {
    this._conversation.actions.createUpdateTopicsAction(added, removed, this._user);
    this._topics.updateConversationLists(this._conversation, added, removed);
    this._conversation.updateTopicIds(added, removed);
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
    this._topic.conversations.add(conversation);
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
  moveConversation: function(topic) {
    this._conversation.actions.createMoveConversationAction(topic, this._user);
    this.viewTopic(this._topics.current());
  },
  updateTitleAndFavicon: function() {
    if (this._faviconAndTitle) {
      this._faviconAndTitle.render();
    }
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
