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
	initialize: function(data, opened_conversation) {
		var self = this;
		self.opened_conversation = opened_conversation;
		self.conversations = new ConversateApp.Collections.Conversations(data.conversations);
		new ConversateApp.Routers.Conversations({ conversations: self.conversations});
		Backbone.history.start();

		setInterval(function () {
			console.log('fetch');
    		self.conversations.fetch();
		}, 5000);
	}
}
