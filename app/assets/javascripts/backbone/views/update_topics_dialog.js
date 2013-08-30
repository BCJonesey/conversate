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
    'click .act-ut-header': 'changeMode',
    'click .act-ut-topic': 'toggleCheck'
  },
  changeMode: function() {
    this.$el.find('.act-ut-topics-list').toggleClass('single-select-mode');
  },
  toggleCheck: function(e) {

    var t = $(e.target).closest('.act-ut-topic');
    var ts = this.$el.find('.checked');
    var tl = this.$el.find('.act-ut-topics-list');

    if (tl.hasClass('single-select-mode')) {
      ts.removeClass('checked');
      t.addClass('checked');
    } else {
      if (ts.length <= 1 && (t.hasClass('checked') === true)) {
        t.toggleClass('checked');
        tl.addClass('empty');
      } else {
        t.toggleClass('checked');
        this.$el.addClass('emtpy');
      }
    }
  }
})
