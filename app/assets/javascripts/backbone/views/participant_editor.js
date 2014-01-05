Structural.Views.ParticipantEditor = Support.CompositeView.extend({
  className: 'btn-group act-participants-editor',
  template: JST.template('participants/editor'),
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;
    this.addressBook = options.addressBook;

    Structural.on('clickAnywhere', this.saveAndCloseIfClickOff, this);
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .act-participants-editor-toggle': 'toggleEditor',
    'click .act-participants-editor-popover .popover-close': 'toggleEditor',
    'click .act-participants-save': 'saveAndClose'
  },

  toggleEditor: function(e) {
    if (e) { e.preventDefault(); }

    this.$('.act-participants-editor-popover').toggleClass('hidden');
    this.$('.act-participants-editor-toggle').toggleClass('active');
  },
  saveAndClose: function(e) {
    if (e) { e.preventDefault(); }
    // TODO: Commit changes
    this.toggleEditor();
  },
  saveAndCloseIfClickOff: function(e) {
    var target = $(e.target);
    if (target.closest('.act-participants-editor').length === 0 && this._isOpen()) {
      this.saveAndClose();
    }
  },

  _isOpen: function() {
    return !this.$('.act-participants-editor-popover').hasClass('hidden');
  }
});
