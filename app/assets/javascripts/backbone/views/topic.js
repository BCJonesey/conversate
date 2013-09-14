// A view for an actual topic in the topics list.

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
    var self = this;
    self.model.on('change', self.reRender, self);
    self.model.on('updated', function() {
      console.log('topic view updating');
    }, self);
  },
  render: function() {
    this.$el.html(this.template({ topic: this.model }));
    return this;
  },
  events: {
    'click': 'viewTopic'
  },
  viewTopic: function(e) {
    e.preventDefault();
    Structural.viewTopic(this.model);
  },
  reClass: function() {
    this.el.className = this.className();
  },
  reRender: function() {
    this.reClass();
    this.render();
  }
});
