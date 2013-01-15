#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

var ConversateApp = {
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},
	initialize: function(data) {
		var conversations = new ConversateApp.Collections.Conversations(data.conversations);
		new ConversateApp.Routers.Conversations({ conversations: conversations});
		Backbone.history.start();
	}
}