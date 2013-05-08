Structural.Views.TopicToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar tpc-toolbar clearfix',
  template: JST['backbone/templates/topics/toolbar'],
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click a.tpc-new-button': 'newTopic'
  },
  newTopic: function(e) {
    e.preventDefault();
    this.trigger('new_topic');
  }
});
