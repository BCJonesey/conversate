Structural.Views.Topics = Support.CompositeView.extend({
  className: 'tpc-list',
  topicHint: $('<div class="tpc-hint hidden">Move conversation to...</div>'),
  initialize: function(options) {
    this.collection.on('add', this.renderTopic, this);
    this.moveMode = false;
  },
  render: function() {
    this.$el.append(this.topicHint);
    this.collection.forEach(this.renderTopic, this);
    return this;
  },
  renderTopic: function(topic) {
    var topicView = new Structural.Views.Topic({model: topic});
    this.appendChild(topicView);
    topicView.on('click', this.topicClicked, this);
  },

  moveConversationMode: function() {
    this.$('.tpc-hint').removeClass('hidden');
    this.moveMode = true;
    Structural.on('clickAnywhere', this.leaveMoveConversationMode, this);
  },
  leaveMoveConversationMode: function(e) {
    if (!e || $(e.target).closest('.tpc-container, .act-title').length == 0) {
      this.$('.tpc-hint').addClass('hidden');
      this.moveMode = false;
      Structural.off('clickAnywhere', this.leaveMoveConversationMode, this);
    }
  },
  topicClicked: function(model) {
    if(this.moveMode) {
      Structural.moveConversation(model);
    }
    else {
      Structural.viewTopic(model);
    }
  }
});
