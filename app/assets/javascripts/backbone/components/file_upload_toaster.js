Structural.Components.FileUploadToaster = function() {

  // Once we have more toast types, make this more generic.
  var getViewDescription = function(toastDescription) {
    var viewDescription = {};
    viewDescription.state = toastDescription.state;
    if (toastDescription.type === 'fileupload:upload') {
      viewDescription.promptRefresh = false;
      viewDescription.message =
        "Water Cooler encountered an error uploading this file, and the upload has not gone through. " +
        "Please try again shortly.";
    }

    return viewDescription;
  };

  this.view = new Structural.Views.Toast();

  this.toast = function(toastDescription) {
    if (toastDescription.state === 'error') {
      var viewDescription = getViewDescription(toastDescription);
      this.view.show(viewDescription);
    } else if (toastDescription.state === 'success') {
      this.view.hide();
    }
  };
};
