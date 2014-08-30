Structural.Views.NewFolder = Support.CompositeView.extend({
  className: 'fld-new hidden',
  template: JST.template('folders/new_folder_input'),
  render: function() {
    this.$el.html(this.template());
    this.inpt = this.$('.fld-new-input');
    return this;
  },
  events: {
    submit: 'createFolder'
  },
  createFolder: function(e) {
    e.preventDefault();
    this.trigger('create_folder', this.inpt.val());
    this.cancel();
  },
  edit: function() {
    this.$el.removeClass('hidden');
    this.listenTo(Structural, 'clickAnywhere', this.cancel, this);
    this.inpt.focus();
  },
  cancel: function(e) {
    if (!e || $(e.target).closest('.fld-container').length == 0) {
      this.inpt.val('');
      this.$el.addClass('hidden');
      Structural.off('clickAnywhere', this.cancel, this);
    }
  }
});
