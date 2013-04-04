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
    Backbone.history.start({pushState: true});

    // TODO: Does any fetching stuff need to go here? I kind of think it might
    //       all fit in the models/collections.

    this._topics = new Structural.Collections.Topics(bootstrap.topics);
    this._conversations = new Structural.Collections.Conversations(bootstrap.conversations);
    this._actions = new Structural.Collections.Actions(bootstrap.actions);
    this._participants = new Structural.Collections.Participants(bootstrap.participants);
    this._conversation = new Structural.Models.Conversation(bootstrap.conversation);
    this._user = new Structural.Models.User(bootstrap.user);

    var bar = new Structural.Views.StructuralBar({model: user});
    var watercooler = new Structural.Views.WaterCooler({
      topics: this._topics,
      conversations: this._conversations,
      actions: this._actions,
      participants: this._participants,
      conversation: this._conversation
    });

    this.appendChild(bar);
    this.appendChild(watercooler);

    return this;
  },

  focus: function(targets) {
    if (targets.topic) {
      this._topics.focus(targets.topic);
    }

    if (targets.conversation) {
      this._conversations.focus(targets.conversation);
    }

    if (targets.message) {
      this._actions.focus(targets.message);
    }
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
