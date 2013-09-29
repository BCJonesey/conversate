Structural.Collections.Folders = Backbone.Collection.extend({
  model: Structural.Models.Folder,
  url: Structural.apiPrefix + '/folders',
  comparator: 'created_at',

  initialize: function(models, options) {
    var self = this;
    options = options || {};
    if (options.isMainCollection) {
      self.on('add', function(folder) {
        folder.on('updated', function() {

          // TODO: Replace with event.
          Structural.updateTitleAndFavicon();

        })
      }, self);

      Structural.on('changeConversation', this.focusAlternates, this);
      Structural.on('clearConversation', this.focusAlternates, this);
    }
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
  // 'Alternate' folders are ones that the given conversation is in, but aren't
  // the current folder.
  focusAlternates: function(conversation) {
    var ids = conversation ? conversation.get('folder_ids') : [];
    this.each(function(folder) {
      if (_.contains(ids, folder.id)) {
        folder.focusAlternate();
      } else {
        folder.unfocusAlternate();
      }
    }, this);
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
  },

  createNewFolder: function(title) {
    var participants = new Structural.Collections.FolderParticipants();
    participants.add(new Structural.Models.Participant({
      email: Structural._user.get('email'),
      full_name: Structural._user.get('full_name')
    }));

    var folder = new Structural.Models.Folder({
      name: title,
      unread_conversations: 0,
      users: participants
    });
    this.add(folder);

    folder.save({}, {
      success: function(model, response) {
        folder.conversations.folderId = model.id;
        folder.trigger('edit', folder);
      }
    });
  }
});
