Structural.Views.FolderToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar fld-toolbar clearfix',
  template: JST.template('folders/toolbar'),
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click a.fld-new-button': 'newFolder',
    'click .toggle-stm-button': 'showStm'
  },
  newFolder: function(e) {
    e.preventDefault();
    Structural.createNewFolder();
  },
  showStm: function(e) {
    e.preventDefault();
    this.$('.structural-menu').toggleClass('hidden');
    this.$('.toggle-stm-button').toggleClass('active');
  }
});
