Structural.Views.NewTopic = Backbone.View.extend({
  className: 'tpc-new hidden',
  render: function() {
    this.$el.html(JST['backbone/templates/topics/new_topic_input']());
    return this;
  },
  events: {
    submit: 'createTopic'
  },
  createTopic: function() {
    // TODO: Create new topic.
  }
});
