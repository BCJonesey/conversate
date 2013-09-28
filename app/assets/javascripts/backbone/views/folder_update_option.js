Structural.Views.TopicUpdateOption = Support.CompositeView.extend({
  className: function() {
    classes = 'act-ut-topic';
    if (this.topic && this.topic_ids && this.topic_ids.indexOf(this.topic.id) >= 0) {
      classes += ' checked';
    }
    return classes;
  },
  template: JST['backbone/templates/actions/update_topics_option'],
  initialize: function(options) {
    options = options || {};
    this.topic = options.topic;
    this.topic_ids = options.topic_ids;
  },
  render: function() {;
    this.$el.html(this.template({topic: this.topic}));
    // Sometimes Backbone seems to like calling className before initialize
    this.el.className = this.className();
  },
  events: {
    'click': 'toggleChecked'
  },
  toggleChecked: function(e) {
    // Ideally I think part of this should happen in the parent view, but...
    // ... fuck it.
    var clicked = this.$el;
    var list = this.$el.closest('.act-ut-topics-list');
    var checked = list.find('.checked');

    if (clicked.hasClass('checked')) {
      if (checked.length > 1) {
        clicked.removeClass('checked');
        this.topic.trigger('unchecked', this.topic);
      }

      var newChecked = list.find('.checked');
      if (newChecked.length === 1) {
        newChecked.addClass('last');
      }
    } else {
      clicked.addClass('checked');
      this.topic.trigger('checked', this.topic);
      list.find('.last').removeClass('last');
    }
  }
});
