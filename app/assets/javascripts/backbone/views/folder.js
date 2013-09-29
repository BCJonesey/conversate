// A view for an actual folder in the folders list.

Structural.Views.Folder = Support.CompositeView.extend({
  className: function() {
    var classes = 'fld';
    if (this.model.get('is_current')) {
      classes += ' fld-current';
    }

    if (this.model.get('is_alternate')) {
      classes += ' fld-alternate';
    }

    if (this.model.get('is_unread')) {
      classes += ' fld-unread';
    }

    return classes;
  },
  template: JST['backbone/templates/folders/folder'],
  initialize: function(options) {
    var self = this;
    self.model.on('change', self.reRender, self);
    self.model.on('updated', function() {
      self.reRender();
    }, self);
  },
  render: function() {
    this.$el.html(this.template({ folder: this.model }));
    return this;
  },
  events: {
    'click .fld-details-toggle': 'editFolder',
    'click': 'viewFolder'
  },
  viewFolder: function(e) {
    e.preventDefault();
    Structural.viewFolder(this.model);
  },
  editFolder: function(e) {
    e.preventDefault();
    this.model.trigger('edit', this.model);
  },
  reClass: function() {
    this.el.className = this.className();
  },
  reRender: function() {
    this.reClass();
    this.render();
  }
});
