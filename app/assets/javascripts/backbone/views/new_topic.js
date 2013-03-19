Structural.Views.NewTopic = Support.CompositeView.extend({
  className: 'tpc-new hidden',
  template: JST['backbone/templates/topics/new_topic_input'],
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    submit: 'createTopic'
  },
  createTopic: function() {
    // TODO: Create new topic.
  }
});
