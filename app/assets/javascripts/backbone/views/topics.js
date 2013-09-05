// A view for an actual topics list.

Structural.Views.Topics = Support.CompositeView.extend({
  className: 'tpc-list',
  topicHint: $('<div class="tpc-hint hidden">Move conversation to...</div>'),
  initialize: function(options) {
    this.collection.on('add', this.renderTopic, this);
  },
  render: function() {
    this.$el.append(this.topicHint);
    this.collection.forEach(this.renderTopic, this);
    return this;
  },
  renderTopic: function(topic) {
    var topicView = new Structural.Views.Topic({model: topic});
    this.appendChild(topicView);
  }
});
