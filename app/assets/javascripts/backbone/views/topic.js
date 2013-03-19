Structural.Views.Topic = Support.CompositeView.extend({
  className: 'tpc',
  template: JST['backbone/templates/topics/topic'],
  initialize: function(options) {
    // TODO: Check for opened topic, update className.
  },
  render: function() {
    this.$el.html(this.template({ topic: this.model }));
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
