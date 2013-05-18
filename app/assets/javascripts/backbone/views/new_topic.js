Structural.Views.NewTopic = Support.CompositeView.extend({
  className: 'tpc-new hidden',
  template: JST['backbone/templates/topics/new_topic_input'],
  render: function() {
    this.$el.html(this.template());
    this.inpt = this.$('.tpc-new-input');
    return this;
  },
  events: {
    submit: 'createTopic'
  },
  createTopic: function(e) {
    e.preventDefault();
    this.trigger('create_topic', this.inpt.val());
    this.cancel();
  },
  edit: function() {
    this.$el.removeClass('hidden');
    Structural.on('clickAnywhere', this.cancel, this);
    this.inpt.focus();
  },
  cancel: function(e) {
    if (!e || $(e.target).closest('.tpc-container').length == 0) {
      this.inpt.val('');
      this.$el.addClass('hidden');
      Structural.off('clickAnywhere', this.cancel, this);
    }
  }
});
