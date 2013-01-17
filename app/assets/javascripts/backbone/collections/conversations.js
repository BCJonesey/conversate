ConversateApp.Collections.Conversations = Backbone.Collection.extend({
	model: ConversateApp.Models.Conversation,
	url: '/api/conversations'
});