ConversateApp.Views.ConversationsIndex = Backbone.View.extend({
	render: function () {
		console.log('render');
		this.$el.html(JST['backbone/templates/conversations/index']({ conversations: this.collection }));
		return this;
	},
	initialize: function () {
        _.bindAll(this, 'render');

        this.collection.bind('all', this.render);
    }
});
