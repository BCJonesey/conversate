Structural.Components.Toaster = function() {

  // Once we have more toast types, make this more generic.
  var getViewDescription = function(toastDescription) {
    var viewDescription = {};
    viewDescription.state = toastDescription.state;
    if (toastDescription.type === 'backbone:sync') {
      viewDescription.promptRefresh = true;
      viewDescription.promptClose = false;
      viewDescription.message =
        "Water Cooler has lost its connection to the server.  Please refresh" +
        " the page to reconnect.  (Messages written without a server " +
        "connection may be lost.)";
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
