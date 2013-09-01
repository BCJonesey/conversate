Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-update-topics hidden',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
    this.conversation = options.conversation;
    Structural.on('clickAnywhere', this.hideIfClickOff, this);
  },
  render: function() {
    this.$el.html(this.template({
      topics: this.topics,
      selected_ids: this.conversation.get('topic_ids')
    }));
    return this;
  },

  toggleVisible: function() {
    this.$el.toggleClass('hidden');
  },
  hideIfClickOff: function(e) {
    var target = $(e.target);
    if (!this.$el.hasClass('hidden') &&
        target.closest('.act-move-cnv, .act-update-topics').length == 0) {
      this.toggleVisible();
    }
  },

  events: {
    'click .act-ut-topic': 'toggleCheck'
  },
  toggleCheck: function(e) {
    var clicked = $(e.target).closest('.act-ut-topic');
    var checked = this.$el.find('.act-ut-topics-list .checked');
    var tl = this.$el.find('.act-ut-topics-list');

    if (clicked.hasClass('checked')) {
      // Trying to remove a folder
      if (checked.length > 1) {
        clicked.removeClass('checked');
      }
      var new_checked = $('.act-ut-topics-list .checked');
      if (new_checked.length === 1) {
        $('.act-ut-topics-list .checked').addClass('last');
      }
    } else {
      // Trying to add a folder
      clicked.addClass('checked');
      $('.act-ut-topics-list .last').removeClass('last');
    }
  }
})
