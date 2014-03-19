Structural.Views.FileUpload = Support.CompositeView.extend({
  tagName: 'span',
  className: 'popover-wrap act-file-upload',
  template: JST.template('actions/file_upload'),
  events: {
    'click .act-file-upload-button-regular': 'toggleFileUpload',
    'click .act-file-upload-popover .popover-close': 'toggleFileUpload'
  },
  toggleFileUpload: function(e){
    e.preventDefault();
    this.$('.act-file-upload-popover').toggleClass('hidden');
    this.$('.act-file-upload-button-regular').toggleClass('active');
  },
  render: function() {
    var self = this;
    this.$el.html(this.template());
    this.$('#fileupload').fileupload({
      formData: {
        conversation: Structural._conversation.id
      },
      dataType: 'json',
      done: function (e, data) {
        self.toggleFileUpload(e);
        self.$el.toggleClass('is-uploading');
      },
      progressall: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('#progress .bar').css(
            'width',
            progress + '%'
        );
      }
    });
  }
});
