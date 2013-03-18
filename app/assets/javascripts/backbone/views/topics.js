Structural.Views.Topics = Backbone.View.extend({
  className: 'tpc-list',
  render: function() {
    this.collection.forEach(this.renderTopic, this);
  },
  renderTopic: function(topic) {
    var topicView = new Structural.Views.Topic({model: topic});
    this.$el.append(topicView.render().el);
  }
});
