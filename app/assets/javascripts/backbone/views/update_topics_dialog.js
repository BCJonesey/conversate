Structural.Views.UpdateTopicsDialog = Support.CompositeView.extend({
  className: 'act-update-topics',
  template: JST['backbone/templates/actions/update_topics'],
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
})