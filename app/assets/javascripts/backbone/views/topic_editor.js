Structural.Views.TopicEditor = Support.CompositeView.extend({
  className: 'tpc-editor',
  template: JST['backbone/templates/topics/editor'],
  initialize: function(options) {
    options = options || {};
  },
  render: function(topic) {
    if (topic) {
      this.$el.html(this.template({topic: topic}));
    }
    return this;
  },

  show: function(topic) {
    this.render(topic);
    this.$('.modal-background').removeClass('hidden');
  }
});
