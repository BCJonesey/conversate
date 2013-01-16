ConversateApp.Routers.Conversations = Backbone.Router.extend({
	routes: {
		"": "index"
	},

	index: function() {
		console.log("Conversations/index route.");
	}
});