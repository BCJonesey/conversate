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
        conversation: Structural._conversation.id,
        notes: self.$('.act-file-upload-notes').val()
      },
      dataType: 'json',
      done: function (e, data) {
        self.toggleFileUpload(e);
        // Let's set up the spinner to show for 5 seconds.
        self.$el.addClass('is-uploading').delay(5000).queue(function() {
          self.$el.removeClass('is-uploading').dequeue();
        })
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
