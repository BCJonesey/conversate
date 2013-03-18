Structural.Views.Topic = Backbone.View.extend({
  className: 'tpc',
  initialize: function(options) {
    // TODO: Check for opened topic, update className.
  },
  render: function() {
    this.$el.html(JST['backbone/templates/topics/topic']({ topic: this.model }));
    return this;
  },
  events: {
    'click a': 'changeTopic'
  },
  changeTopic: function(e) {
    // TODO: move to new topic via Backbone.history.navigate.
    // TODO: Figure out our user-facing routes so we know what goes here.
  }
});
