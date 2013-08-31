Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-update-topics hidden',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
  },
  render: function() {
    this.$el.html(this.template(this.topics));
    return this;
  },

  toggleVisible: function() {
    this.$el.toggleClass('hidden');
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
