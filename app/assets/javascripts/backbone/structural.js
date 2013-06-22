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
    this._topics = new Structural.Collections.Topics(bootstrap.topics);
    this._conversations = new Structural.Collections.Conversations(bootstrap.conversations);
    this._conversation =  this._conversations.where({id: bootstrap.conversation.id})[0];
    this._participants = new Structural.Collections.Participants(
      bootstrap.participants,
      {conversation: this._conversation ? this._conversation.id : undefined}
    );
    if (!this._conversation) {
      this._conversation = new Structural.Models.Conversation();
    }
    this._user = new Structural.Models.User(bootstrap.user);
    if (this._conversation && this._conversation.id) {
      this._actions = new Structural.Collections.Actions(bootstrap.actions, {conversation: this._conversation.id, user:this._user.id});
      this._actions._lieAboutActionsSoItLooksNiceToHumans();
      this._actions._daisyChainUnreadCascade();
      this._actions._findMyMessages();
    } else {
      this._actions = new Structural.Collections.Actions();
    }

    this._bar = new Structural.Views.StructuralBar({model: this._user});
    this._watercooler = new Structural.Views.WaterCooler({
      topics: this._topics,
      conversations: this._conversations,
      actions: this._actions,
      participants: this._participants,
      conversation: this._conversation,
      addressBook: this._user.get('address_book')
    });
    this._faviconAndTitle = new Structural.Views.FaviconAndTitle({
      topics: this._topics
    });

    if (this._actions) {
      this._participants.on('reset', this._actions.calculateUnreadedness, this._actions);
      this._actions.calculateUnreadedness(this._participants);
    }

    this.appendChild(this._bar);
    this.appendChild(this._watercooler);
    this._faviconAndTitle.render();

    Backbone.history.start({pushState: true});
    return this;
  },

  events: {
    'click': 'clickAnywhere'
  },
  clickAnywhere: function(e) {
    this.trigger('clickAnywhere', e);
  },

  focus: function(targets) {
    if (targets.topic) {
      this._topics.focus(targets.topic);
      this._conversations.setTopic(targets.topic);
    }

    if (targets.conversation) {
      this._conversations.focus(targets.conversation);
    }

    if (targets.message) {
      this._actions.focus(targets.message);
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

  viewConversation: function(conversation) {
    if (conversation.id !== this._conversation.id) {
      this._changeConversationView(conversation);
      this._changeConversationUrl(conversation);
    }
  },
  viewTopic: function(topic) {
    var self = this;
    if (!self._conversation || topic.id !== self._conversation.topid_id) {
      self._conversations.changeTopic(topic.id, function(collection) {
        if (collection.length > 0) {
          self._changeConversationView(collection.at(0));
        }
        else {
          self._clearConversationView();
        }
      });
      Structural.Router.navigate(Structural.Router.topicPath(topic),
                                 {trigger: true});
    }
  },

  _changeConversationView: function(conversation) {
    this._conversation = conversation;
    this._actions.changeConversation(conversation.id);
    this._participants.changeConversation(conversation.id);
    this._watercooler.changeConversation(conversation);
  },
  _changeConversationUrl: function(conversation) {
    Structural.Router.navigate(Structural.Router.conversationPath(conversation),
                               {trigger: true});
  },
  _clearConversationView: function() {
    this._conversation = undefined;
    this._actions.clearConversation();
    this._participants.clearConversation();
    this._watercooler.clearConversation();
  },

  createRetitleAction: function(title) {
    this._actions.createRetitleAction(title, this._user);
  },
  createUpdateUserAction: function(added, removed) {
    this._actions.createUpdateUserAction(added, removed, this._user);
  },
  createMessageAction: function(text) {
    this._actions.createMessageAction(text, this._user);
  },
  createDeleteAction: function(action) {
    this._actions.createDeleteAction(action, this._user);
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
    var conversation = new Structural.Models.Conversation(data);
    this._conversations.add(conversation);
    conversation.save();
    // TODO: navigate to conversation
  },
  moveConversation: function(topic) {
    this._actions.createMoveConversationAction(topic, this._user);
    this.viewTopic(this._topics.current());
  },
  updateReadTimestamp: function(action) {
    this._participants.get(this._user.id).updateReadTimestamp(action.get('timestamp'));
  },
  updateUnreadCounts: function() {
    this._conversation.updateUnreadCount(this._actions);
    var topic = this._topics.get(this._conversation.get('topic_id'));
    topic.updateUnreadCount(this._conversations);
    this.updateTitleAndFavicon();
  },
  updateTitleAndFavicon: function() {
    this._faviconAndTitle.render();
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
