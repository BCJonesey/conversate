Structural.Views.Conversation = Backbone.View.extend({
  className: 'cnv',
  initialize: function(options) {
    if (this.model.attributes.most_recent_message > this.model.attributes.most_recent_viewed) {
      this.className += ' cnv-unread';
    }

    // TODO: Figure out how we're storing current conversation, update class.

    this.model.attributes.participants.sort(function(a, b) { return a.last_updated_time - b.last_updated_time; });
  },
  render: function() {
    this.$el.html(JST['backbone/templates/conversations/conversation']({conversation: this.model}));
    return this;
  }
});
