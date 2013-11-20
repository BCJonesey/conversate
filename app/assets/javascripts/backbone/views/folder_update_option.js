Structural.Views.FolderUpdateOption = Support.CompositeView.extend({
  className: function() {
    classes = 'act-ut-folder';
    if (this.folder && this.folder_ids && this.folder_ids.indexOf(this.folder.id) >= 0) {
      classes += ' checked';
    }
    return classes;
  },
  template: JST.template('actions/update_folders_option'),
  initialize: function(options) {
    options = options || {};
    this.folder = options.folder;
    this.folder_ids = options.folder_ids;
  },
  render: function() {;
    this.$el.html(this.template({folder: this.folder}));
    // Sometimes Backbone seems to like calling className before initialize
    this.el.className = this.className();
  },
  events: {
    'click': 'toggleChecked'
  },
  toggleChecked: function(e) {
    // Ideally I think part of this should happen in the parent view, but...
    // ... fuck it.
    var clicked = this.$el;
    var list = this.$el.closest('.act-ut-folders-list');
    var checked = list.find('.checked');

    if (clicked.hasClass('checked')) {
      if (checked.length > 1) {
        clicked.removeClass('checked');
        this.folder.trigger('unchecked', this.folder);
      }

      var newChecked = list.find('.checked');
      if (newChecked.length === 1) {
        newChecked.addClass('last');
      }
    } else {
      clicked.addClass('checked');
      this.folder.trigger('checked', this.folder);
      list.find('.last').removeClass('last');
    }
  }
});
