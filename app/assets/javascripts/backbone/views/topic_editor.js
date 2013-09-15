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

  events: {
    'click .ef-save-button': 'save'
  },

  show: function(topic) {
    this._topic = topic;
    this.render(topic);
    this.$('.modal-background').removeClass('hidden');
  },
  save: function(e) {
    e.preventDefault();
    if (this._topic) {
      // TODO: Save this._topic
    }
  }
});
