Structural.Collections.Folders = Backbone.Collection.extend({
  model: Structural.Models.Folder,
  url: Structural.apiPrefix + '/folders',
  comparator: 'created_at',

  initialize: function(options) {
    var self = this;
    options = options || {};
    self.on('add', function(folder) {
      folder.on('updated', function() {

        // TODO: Replace with event.
        Structural.updateTitleAndFavicon();

      })
    }, self);
  },

  focus: function(id) {
    var folder = this.get(id);
    if(folder) {
      folder.focus();
    }

    this.filter(function(fld) { return fld.id != id; }).forEach(function(fld) {
      fld.unfocus();
    });
  },
  current: function() {
    return this.where({is_current: true}).pop();
  },

  updateConversationLists: function(conversation, addedFolders, removedFolders) {
    addedFolders.forEach(function(folder) {
      folder.conversations.add(conversation);
    });

    removedFolders.forEach(function(folder) {
      folder.conversations.remove(conversation);
    })
  }
});
