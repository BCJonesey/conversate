(function() {
  var ConsecutiveErrorsRequiredToToast = 2;
  Backbone._originalSync = Backbone.sync;

  var consecutiveErrors = 0;

  /* Modeled closely on wrapError from the Backbone source. */
  Backbone.sync = function(method, model, options) {
    var originalError = options.error;
    options.error = function(model, resp, options) {
      consecutiveErrors += 1;

      // When the response status is 0 we didn't actually get an HTTP response,
      // the request was killed by something the browser is doing, like
      // refreshing the page or the computer going to sleep.  Not actually an
      // error.

      if (model.status >= 300 &&
          consecutiveErrors >= ConsecutiveErrorsRequiredToToast) {
        Structural.Toaster.toast({
          state: 'error',
          type: 'backbone:sync'
        });
      }

      if (originalError) {
        originalError(model, resp, options);
      }
    };

    var originalSuccess = options.success;
    options.success = function(model, resp, options) {
      consecutiveErrors = 0;

      Structural.Toaster.toast({
        state: 'success',
        type: 'backbone:sync'
      });

      if (originalSuccess) {
        originalSuccess(model, resp, options);
      }
    };

    Backbone._originalSync(method, model, options);
  };
})();
