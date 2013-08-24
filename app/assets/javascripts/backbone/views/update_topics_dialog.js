Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-update-topics',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .act-ut-header': 'changeMode',
    'click .topic': 'toggleCheck'
  },
  changeMode: function() {
    this.$el.find('.topics-list').toggleClass('single-select-mode');
  },
  toggleCheck: function(e) {

    var t = $(e.target).closest('.topic');
    var ts = this.$el.find('.checked');
    var tl = this.$el.find('.topics-list');

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
