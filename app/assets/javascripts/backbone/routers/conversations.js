ConversateApp.Routers.Conversations = Backbone.Router.extend({
	routes: {
		"": "index"
	},
	index: function() {
		var view = new ConversateApp.Views.ConversationsIndex({collection: ConversateApp.conversations })
		$('#conversations-list').html(view.render().$el);
	}
});