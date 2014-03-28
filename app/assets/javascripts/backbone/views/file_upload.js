Structural.Views.FileUpload = Support.CompositeView.extend({
  tagName: 'span',
  className: 'popover-wrap act-file-upload',
  template: JST.template('actions/file_upload'),
  events: {
    'click .act-file-upload-button-regular': 'toggleFileUpload',
    'click .act-file-upload-popover .popover-close': 'toggleFileUpload',
    'keyup .act-file-upload-notes': 'keyupUploadNotes',
    'click .act-file-upload-submit': 'submitFileUpload'
  },
  submitFileUpload: function(e) {
    if (this.uploadData) {
      this.uploadData.submit();
      this.uploadData = null;
    }
  },
  toggleFileUpload: function(e){
    e.preventDefault();
    this.$('.act-file-upload-popover').toggleClass('hidden');
    this.$('.act-file-upload-button-regular').toggleClass('active');
    self.uploadData = null;
    this.updateProgress(0);
    this.clearFilePicked(e);
  },
  showFilePicked: function(e, filename) {
    self.$('.act-file-upload-filename').text(filename);
    self.$('.act-file-upload-picker').addClass('file-picked');
  },
  clearFilePicked: function(e) {
    self.$('.act-file-upload-picker').removeClass('file-picked');
  },
  keyupUploadNotes: function(e) {
    this.updateFileUpload();
  },
  render: function() {
    this.$el.html(this.template());
    this.updateFileUpload();
  },
  updateFileUpload: function() {
    var self = this;
    this.$('#fileupload').fileupload({
      formData: {
        conversation: Structural._conversation.id,
        notes: self.$('.act-file-upload-notes').val()
      },
      autoUpload: false,
      dataType: 'json',
      done: function (e, data) {
        self.toggleFileUpload(e);
        self.$('.act-file-upload-notes').val('');
        self.updateFileUpload();

        // Let's set up the spinner to show for 5 seconds.
        self.$el.addClass('is-uploading').delay(5000).queue(function() {
          self.$el.removeClass('is-uploading').dequeue();
        })
      },
      progressall: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        self.updateProgress(progress);
      },
      add: function (e, data) {
        self.uploadData = data;
        self.showFilePicked(e, data.files[0].name);
      }
    });
  },
  updateProgress: function(intPercent) {
    $('#progress .bar').css(
        'width',
        intPercent + '%'
    );
  }
});
