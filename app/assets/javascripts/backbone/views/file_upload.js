Structural.Views.FileUpload = Support.CompositeView.extend({
  tagName: 'span',
  className: 'popover-wrap',
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
    this.$('#fileupload').fileupload({
        dataType: 'json',
        done: function (e, data) {
            $.each(data.result.files, function (index, file) {
                $('<p/>').text(file.name).appendTo(document.body);
            });
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
