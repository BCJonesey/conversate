#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

var ConversateApp = {
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},
	initialize: function(data) {
		this.conversations = new ConversateApp.Collections.Conversations(data.conversations);
		new ConversateApp.Routers.Conversations({ conversations: this.conversations});
		Backbone.history.start();
	}
}