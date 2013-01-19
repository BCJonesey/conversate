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
		var self = this;
		self.conversations = new ConversateApp.Collections.Conversations(data.conversations);
		new ConversateApp.Routers.Conversations({ conversations: self.conversations});
		Backbone.history.start();

		setInterval(function () {
			console.log('fetch');
    		self.conversations.fetch({update: true});
		}, 5000);
	}
}