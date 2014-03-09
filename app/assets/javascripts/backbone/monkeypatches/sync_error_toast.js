(function() {
  Backbone._originalSync = Backbone.sync;

  /* Modeled closely on wrapError from the Backbone source. */
  Backbone.sync = function(method, model, options) {
    var originalError = options.error;
    options.error = function(model, resp, options) {
      // When the response status is 0 we didn't actually get an HTTP response,
      // the request was killed by something the browser is doing, like
      // refreshing the page or the computer going to sleep.  Not actually an
      // error.

      if (model.status >= 300) {
        Structural.Toaster.toast({
          state: 'error',
          errorType: 'backbone:sync'
        });
      }

      if (originalError) {
        originalError(model, resp, options);
      }
    };

    Backbone._originalSync(method, model, options);
  };
})();
