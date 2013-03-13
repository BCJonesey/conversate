ConversateApp.Routers.Conversations = Backbone.Router.extend({
	routes: {
    'conversations/:id': 'index',
    'conversations/:id/:action': 'index'
	},
	index: function(id) {
    ConversateApp.opened_conversation = id;
    ConversateApp.conversations.fetch({
                                  update: true,
                                  data: $.param({
                                    id: ConversateApp.opened_conversation
                                  })
                                });

    if (!ConversateApp.conversationView) {
      ConversateApp.conversationView = new ConversateApp.Views.ConversationsIndex(
                                  {collection: ConversateApp.conversations } );
    }
    ConversateApp.conversationView.collection = ConversateApp.conversations;


		$('#conversations-list').html(ConversateApp.conversationView.render().$el);

    if (ConversateApp.opened_conversation) {

      // Conversation info rendering.
      var conversation = ConversateApp.conversations.get(ConversateApp.opened_conversation);
      if (!ConversateApp.conversationInfoView) {
        ConversateApp.conversationInfoView = new ConversateApp.Views.ConversationInfo({conversation: conversation});
      } else {
        ConversateApp.conversationInfoView.options.conversation = conversation;
      }

      $('#conversation-info').html(ConversateApp.conversationInfoView.render().$el);

      setupConversationEditor(conversation.get('participant_tokens'));

      // Message rendering.
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
