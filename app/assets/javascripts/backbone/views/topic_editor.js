Structural.Views.TopicEditor = Support.CompositeView.extend({
  className: 'tpc-editor hidden',
  template: JST['backbone/templates/topics/editor'],
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },

  show: function(topic) {
    this.$el.removeClass('hidden');
  }
});
