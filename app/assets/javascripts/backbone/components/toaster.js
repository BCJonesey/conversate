Structural.Components.Toaster = function() {

  // Once we have more toast types, make this more generic.
  var getViewDescription = function(toastDescription) {
    var viewDescription = {};
    viewDescription.state = toastDescription.state;
    if (toastDescription.errorType === 'backbone:sync') {
      viewDescription.promptRefresh = true;
      viewDescription.message =
        "Water Cooler has lost it's connection to the server.  Please refresh" +
        " the page to reconnection.  (Messages written without a server " +
        "connection may be lost.)";
    }

    return viewDescription;
  };

  this.view = new Structural.Views.Toast();

  this.toast = function(toastDescription) {
    var viewDescription = getViewDescription(toastDescription);
    this.view.show(viewDescription);
  };
};
