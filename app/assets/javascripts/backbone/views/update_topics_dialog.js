Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-ut hidden',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
    this.topic_ids = options.conversation.get('topic_ids');
    this.original_topic_ids = _.clone(this.topic_ids);
    Structural.on('clickAnywhere', this.hideIfClickOff, this);
    this.topics.each(function(topic) {
      topic.on('checked', this.addTopic, this);
      topic.on('unchecked', this.removeTopic, this);
    }, this);
  },
  render: function() {
    this.$el.html(this.template());
    this.topics.each(function(topic) {
      this.renderOption(topic);
    }, this);
    return this;
  },
  renderOption: function(topic) {
    var option = new Structural.Views.TopicUpdateOption({
      topic: topic,
      topic_ids: this.topic_ids
    });
    this.appendChildTo(option, this.$el.find('.act-ut-topics-list'));
  },

  toggleVisible: function() {
    this.$el.toggleClass('hidden');
    if (this.$el.hasClass('hidden')) {
      this.save();
    }
  },
  hideIfClickOff: function(e) {
    var target = $(e.target);
    if (!this.$el.hasClass('hidden') &&
        target.closest('.act-move-cnv, .act-ut').length == 0) {
      this.toggleVisible();
    }
  },

  addTopic: function(topic) {
    this.topic_ids.push(topic.id);
  },
  removeTopic: function(topic) {
    this.topic_ids = _.without(this.topic_ids, topic.id);
  },
  save: function() {
    var added_ids = _.difference(this.topic_ids, this.original_topic_ids);
    var removed_ids = _.difference(this.original_topic_ids, this.topic_ids);

    if (added_ids.length === 0 && removed_ids.length === 0) {
      return;
    }

    var self = this;
    var added = added_ids.map(function(id) { return self.topics.get(id); });
    var removed = removed_ids.map(function(id) { return self.topics.get(id); });

    Structural.createUpdateTopicsAction(added, removed);
    this.original_topic_ids = _.clone(this.topic_ids);
  }
});
