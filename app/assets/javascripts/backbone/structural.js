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
    // TODO: Backbone.history.start({pushState: true});
    // TODO: Does any fetching stuff need to go here? I think of think it might
    //       all fit in the models/collections.

    var topics = new Structural.Collections.Topics(bootstrap.topics);
    var conversations = new Structural.Collections.Conversations(bootstrap.conversations);
    var actions = new Structural.Collections.Actions(bootstrap.actions);
    var participants = new Structural.Collections.Participants(bootstrap.participants);
    var conversation = new Structural.Models.Conversation(bootstrap.conversation);
    var user = new Structural.Models.User(bootstrap.user);

    var bar = new Structural.Views.StructuralBar({model: user});
    var watercooler = new Structural.Views.WaterCooler({
      topics: topics,
      conversations: conversations,
      actions: actions,
      participants: participants,
      conversation: conversation
    });

    this.appendChild(bar);
    this.appendChild(watercooler);

    return this;
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
