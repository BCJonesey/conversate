// A view for the folders toolbar and a container for the actual
// folders list.

Structural.Views.FolderContainer = Support.CompositeView.extend({
  className: ' ui-section fld-container',
  initialize: function(options) {
    options = options || {};
    this.folders = options.folders;
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.toolbarView = new Structural.Views.FolderToolbar();
    this.listView = new Structural.Views.Folders({
      collection: this.folders,
      addressBook: this.addressBook
    });
    this.inputView = new Structural.Views.NewFolder();

    this.appendChild(this.toolbarView);
    this.appendChild(this.listView);
    this.appendChild(this.inputView);

    this.toolbarView.on('new_folder', this.newFolder, this);
    this.inputView.on('create_folder', this.createFolder, this);
  },

  newFolder: function() {
    this.inputView.edit();
  },

  createFolder: function(name) {
    var model = new Structural.Models.Folder({name: name});
    this.folders.add(model);
    model.save();
  },

  moveConversationMode: function() {
    this.listView.moveConversationMode();
  },
  show: function(show){
    if (show) {
      this.$el.addClass('visible');
    } else {
      this.$el.removeClass('visible');
    }
  }
});
