Structural.Views.Topics = Backbone.View.extend({
  className: 'tpc-list',
  topicHint: $('<div class="tpc-hint">Move conversation to...</div>'),
  render: function() {
    this.$el.append(this.topicHint);
    this.collection.forEach(this.renderTopic, this);
  },
  renderTopic: function(topic) {
    var topicView = new Structural.Views.Topic({model: topic});
    this.$el.append(topicView.render().el);
  }
});
