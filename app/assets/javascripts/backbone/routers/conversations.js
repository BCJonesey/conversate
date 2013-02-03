ConversateApp.Routers.Conversations = Backbone.Router.extend({
	routes: {
		"": "index"
	},
	index: function() {
		var conversationView = new ConversateApp.Views.ConversationsIndex(
                                                        {collection: ConversateApp.conversations });
		$('#conversations-list').html(conversationView.render().$el);

    if (ConversateApp.opened_conversation) {
      var messagesView = new ConversateApp.Views.MessagesIndex(
                                                      {collection: ConversateApp.messages});
      $('#thread').html(messagesView.render().$el);
    }
	}
});
