// A view for an actual topics list.

Structural.Views.Topics = Support.CompositeView.extend({
  className: 'tpc-list',
  topicHint: $('<div class="tpc-hint hidden">Move conversation to...</div>'),
  initialize: function(options) {
    options = options || {};

    this.collection.on('add', this.renderTopic, this);
    this.collection.on('add', function(topic) {
      topic.on('edit', this.editTopic, this);
    }, this);
    this._topicEditor = new Structural.Views.TopicEditor({
      addressBook: options.addressBook
    });
  },
  render: function() {
    this.$el.append(this.topicHint);
    this.appendChild(this._topicEditor);
    this.collection.forEach(this.renderTopic, this);
    return this;
  },
  renderTopic: function(topic) {
    var topicView = new Structural.Views.Topic({model: topic});
    this.appendChild(topicView);
  },

  editTopic: function(topic) {
    this._topicEditor.show(topic);
  }
});
