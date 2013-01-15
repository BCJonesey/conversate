var Conversations = Backbone.Collection.extend({
	model: Conversation,
	url: '/conversations'
});