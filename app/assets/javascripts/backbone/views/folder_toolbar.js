Structural.Views.FolderToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar fld-toolbar clearfix',
  template: JST['backbone/templates/folders/toolbar'],
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click a.fld-new-button': 'newFolder'
  },
  newFolder: function(e) {
    e.preventDefault();
    Structural.createNewFolder();
  }
});
