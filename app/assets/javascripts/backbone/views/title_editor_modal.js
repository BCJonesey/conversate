Structural.Views.TitleEditorModal = Support.CompositeView.extend({
  tagName: 'span',
  className: 'wc-title-editor-wrap popover-wrap',
  template: JST['backbone/templates/actions/title_editor_modal'],
  initialize: function(options) {
    Structural.on('clickAnywhere', this.hide, this);
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .wc-title-editor-toggle': 'toggleModal'
  },

  isOpen: function() {
    return !this.$('.wc-title-editor-popover').hasClass('hidden');
  },
  toggleModal: function() {
    this.$('.wc-title-editor-popover').toggleClass('hidden');
    this.$('.wc-title-editor-toggle').toggleClass('active');
  },
  hide: function(e) {
    var target = $(e.target);
    if (target.closest('.wc-news-wrap').length === 0 && this.isOpen()) {
      this.toggleModal();
    }
  }
});
