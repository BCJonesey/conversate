Structural.Views.FileUpload = Support.CompositeView.extend({
  className: 'act-fileupload',
  template: JST.template('actions/file_upload'),
  events: {
    'click .act-file-upload-toggle': 'toggleFileUpload',
    'click .act-file-upload-popover .popover-close': 'toggleFileUpload'
  },
  toggleFileUpload: function(e){
    e.preventDefault();
    this.$('.act-file-upload-popover').toggleClass('hidden');
    this.$('.act-file-upload-toggle').toggleClass('active');
  },
  render: function() {
    this.$el.html(this.template());
  }
});
