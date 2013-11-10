Structural.Views.UpdateFoldersDialog = Support.CompositeView.extend({
  className: 'act-ut hidden',
  template: JST['backbone/templates/actions/update_folders'],
  initialize: function(options) {
    options = options || {};
    this.folders = options.folders;
    this.folder_ids = options.conversation.get('folder_ids') || [];
    this.original_folder_ids = _.clone(this.folder_ids);
    Structural.on('clickAnywhere', this.hideIfClickOff, this);
    this.folders.each(function(folder) {
      folder.on('checked', this.addFolder, this);
      folder.on('unchecked', this.removeFolder, this);
    }, this);
  },
  render: function() {
    this.$el.html(this.template());
    this.folders.each(function(folder) {
      this.renderOption(folder);
    }, this);
    return this;
  },
  renderOption: function(folder) {
    var option = new Structural.Views.FolderUpdateOption({
      folder: folder,
      folder_ids: this.folder_ids
    });
    this.appendChildTo(option, this.$el.find('.act-ut-folders-list'));
  },

  toggleVisible: function() {
    this.$el.toggleClass('hidden');
    if (this.$el.hasClass('hidden')) {
      this.save();
    }
  },
  hideIfClickOff: function(e) {
    var target = $(e.target);
    if (!this.$el.hasClass('hidden') &&
        target.closest('.act-move-cnv, .act-ut').length == 0) {
      this.toggleVisible();
    }
  },

  addFolder: function(folder) {
    this.folder_ids.push(folder.id);
  },
  removeFolder: function(folder) {
    this.folder_ids = _.without(this.folder_ids, folder.id);
  },
  save: function() {
    var added_ids = _.difference(this.folder_ids, this.original_folder_ids);
    var removed_ids = _.difference(this.original_folder_ids, this.folder_ids);

    if (added_ids.length === 0 && removed_ids.length === 0) {
      return;
    }

    var self = this;
    var added = added_ids.map(function(id) { return self.folders.get(id); });
    var removed = removed_ids.map(function(id) { return self.folders.get(id); });

    Structural.createUpdateFoldersAction(added, removed);
    this.original_folder_ids = _.clone(this.folder_ids);

    if (_.contains(removed_ids, Structural._folder.id)) {
      // View first conversation in folder, if any
      var firstConversation = Structural._folder.conversations.first();
      if (firstConversation) {
        Structural.viewConversation(firstConversation);
      } else {
        Structural.clearConversation();
      }

      Structural.trigger('showResponsiveConversations');
    }
  }
});
