ConversateApp.Views.MessagesIndex = Backbone.View.extend({
  render: function () {
    this.$el.html(JST['backbone/templates/messages/index']({ messages: this.collection }));
    return this;
  },
  initialize: function () {
        _.bindAll(this, 'render');

        this.collection.bind('all', this.render);
    }
});
