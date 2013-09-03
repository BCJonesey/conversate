Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-update-topics hidden',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
    this.topic_ids = options.conversation.get('topic_ids');
    this.original_topic_ids = _.clone(this.topic_ids);
    Structural.on('clickAnywhere', this.hideIfClickOff, this);
    this.topics.each(function(topic) {
      topic.on('checked', this.addTopic, this);
      topic.on('uncheckd', this.removeTopic, this);
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
        target.closest('.act-move-cnv, .act-update-topics').length == 0) {
      this.toggleVisible();
    }
  },

  addTopic: function(topic) {
    this.topic_ids.push(topic.id);
    console.log(this.topic_ids);
  },
  removeTopic: function(topic) {
    this.topic_ids = _.without(this.topic_ids, topic.id);
  },
  save: function() {
    var added_ids = _.difference(this.topic_ids, this.original_topic_ids);
    var removed_ids = _.difference(this.original_topic_ids, this.topic_ids);

    console.log(this.original_topic_ids);
    console.log(this.topic_ids);
    console.log(added_ids);
    console.log(removed_ids);
    console.log(this.topics);

    if (added_ids.length === 0 && removed_ids.length === 0) {
      return;
    }

    var self = this;
    console.log(self.topics.get(2));
    var added = added_ids.map(function(id) { return self.topics.get(id); });
    var removed = removed_ids.map(function(id) { return self.topics.get(id); });

    console.log(added);

    Structural.createUpdateTopicsAction(added, removed);
  }
});
