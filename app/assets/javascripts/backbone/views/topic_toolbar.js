Structural.Views.TopicToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar tpc-toolbar clearfix',
  render: function() {
    this.$el.html(JST['backbone/templates/topics/toolbar']());
    return this;
  },
  events: {
    'click a.tpc-new-button': 'newTopic'
  },
  newTopic: function() {
    // TODO: Create new topic.
  }
});
