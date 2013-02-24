ConversateApp.Routers.Conversations = Backbone.Router.extend({
	routes: {
    'conversations/:id': 'index'
	},
	index: function(id) {
    ConversateApp.opened_conversation = id;

		var conversationView = new ConversateApp.Views.ConversationsIndex(
                                                        {collection: ConversateApp.conversations });
		$('#conversations-list').html(conversationView.render().$el);

    if (ConversateApp.opened_conversation) {
      ConversateApp.messages.reset({});
      ConversateApp.messages.fetch({
                                  update: true,
                                  data: $.param({
                                                  id: ConversateApp.opened_conversation
                                                })
                                  });
      var messagesView = new ConversateApp.Views.MessagesIndex(
                                                      {collection: ConversateApp.messages});
      $('#thread').html(messagesView.render().$el);
    }
	}
});
