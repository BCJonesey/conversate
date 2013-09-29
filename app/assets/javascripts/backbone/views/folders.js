// A view for an actual folders list.

Structural.Views.Folders = Support.CompositeView.extend({
  className: 'fld-list',
  folderHint: $('<div class="fld-hint hidden">Move conversation to...</div>'),
  initialize: function(options) {
    options = options || {};

    this.collection.on('add', this.renderFolder, this);

    // We need to setup edit for all of our bootstrapped folders,
    // in addition to any new folders that get added.
    this.collection.each(function(folder) {
      folder.on('edit', this.editFolder, this);
    }, this);
    this.collection.on('add', function(folder) {
      folder.on('edit', this.editFolder, this);
    }, this);

    this._folderEditor = new Structural.Views.FolderEditor({
      addressBook: options.addressBook
    });
  },
  render: function() {
    this.$el.append(this.folderHint);
    this.appendChild(this._folderEditor);
    this.collection.forEach(this.renderFolder, this);
    return this;
  },
  renderFolder: function(folder) {
    var folderView = new Structural.Views.Folder({model: folder});
    this.appendChild(folderView);
  },

  editFolder: function(folder) {
    this._folderEditor.show(folder);
  }
});
