Structural.Views.Topic = Support.CompositeView.extend({
  className: function() {
    var classes = 'tpc';
    if (this.model.is_current) {
      classes += ' tpc-current';
    }

    return classes;
  },
  template: JST['backbone/templates/topics/topic'],
  initialize: function(options) {
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
