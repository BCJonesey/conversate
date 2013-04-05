Structural.Views.Topic = Support.CompositeView.extend({
  className: function() {
    var classes = 'tpc';
    if (this.model.get('is_current')) {
      classes += ' tpc-current';
    }

    if (this.model.get('is_unread')) {
      classes += ' tpc-unread';
    }

    return classes;
  },
  template: JST['backbone/templates/topics/topic'],
  initialize: function(options) {
    this.model.on('change', this.reRender, this);
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
  },
  reClass: function() {
    this.el.className = this.className();
  },
  reRender: function() {
    this.reClass();
    this.render();
  }
});
