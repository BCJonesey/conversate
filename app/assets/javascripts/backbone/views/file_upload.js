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
    }
  },
  toggleFileUpload: function(e){
    e.preventDefault();
    this.$('.act-file-upload-popover').toggleClass('hidden');
    this.$('.act-file-upload-button-regular').toggleClass('active');
    self.$('.act-file-upload-notes').val('');
    this.uploadData = null;
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
      fail: function(e, data) {
        self.toggleFileUpload(e);
        self.updateFileUpload();

        // Let's set up the toast error message for the user.
        var toastOptions = {
          type: 'fileupload:upload',
          state: 'error'
        }
        if (data.response().jqXHR.status == 422) {
          // This file failed file size validation.
          toastOptions.type = 'fileupload:filesize';
        }
        Structural.FileUploadToaster.toast(toastOptions);
      },
      done: function (e, data) {

        // Note the filename, then do normal file upload cleanup.
        var fileName = self.uploadData.files[0].name
        self.toggleFileUpload(e);
        self.updateFileUpload();

        // When the action comes in that is for this upload, we want to stop the spinner right away.
        Structural._conversation.actions.on('add', function(action) {
          if (fileName === action.get('fileName') ) {
            Structural._conversation.actions.off('add', self);
            self.$el.removeClass('is-uploading')
          }
        }, self);

        // Fetch our actions right away, so we can see our upload ASAP.
        Structural._conversation.actions.fetch();

        // Let's set up the spinner to show for 20 seconds.
        self.$el.addClass('is-uploading').delay(20000).queue(function() {
          self.$el.removeClass('is-uploading').dequeue();
        });

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
