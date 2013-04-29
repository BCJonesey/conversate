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
    // TODO: Does any fetching stuff need to go here? I kind of think it might
    //       all fit in the models/collections.

    this._topics = new Structural.Collections.Topics(bootstrap.topics);
    this._conversations = new Structural.Collections.Conversations(bootstrap.conversations);
    this._participants = new Structural.Collections.Participants(bootstrap.participants);
    this._conversation = this._conversations.where({id: bootstrap.conversation.id})[0];
    this._user = new Structural.Models.User(bootstrap.user);
    this._actions = new Structural.Collections.Actions(bootstrap.actions, {conversation: this._conversation.id});

    this._bar = new Structural.Views.StructuralBar({model: this._user});
    this._watercooler = new Structural.Views.WaterCooler({
      topics: this._topics,
      conversations: this._conversations,
      actions: this._actions,
      participants: this._participants,
      conversation: this._conversation,
      addressBook: this._user.get('address_book')
    });

    this.appendChild(this._bar);
    this.appendChild(this._watercooler);

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

  newConversationMode: function() {
    var view = new Structural.Views.NewConversation({
      addressBook: this._user.get('address_book')
    });
    this.appendChild(view);
  },
  viewConversation: function(conversation) {
    if (conversation.id !== this._conversation.id) {
      this._conversation = conversation;
      this._actions.changeConversation(conversation.id);
      this._participants.changeConversation(conversation.id);
      this._watercooler.changeConversation(conversation);
      Structural.Router.navigate('conversation/' +
                                 this._slugify(conversation.get('title')) +
                                 '/' + conversation.id,
                                 {trigger: true});
    }
  },

  createRetitleAction: function(title) {
    this._actions.createRetitleAction(title, this._user);
  },
  createUpdateUserAction: function(added, removed) {
    console.log(added);
    console.log(removed);

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

  _slugify: function(s) {
    s.toLowerCase()
     .replace('/[ _]/g', '-');
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
