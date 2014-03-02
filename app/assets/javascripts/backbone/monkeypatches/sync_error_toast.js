(function() {
  Backbone._originalSync = Backbone.sync;

  /* Modeled closely on wrapError from the Backbone source. */
  Backbone.sync = function(method, model, options) {
    var originalError = options.error;
    options.error = function(model, resp, options) {
      Structural.Toaster.toast({
        state: 'error',
        errorType: 'backbone:sync'
      });

      if (originalError) {
        originalError(model, resp, options);
      }
    };

    Backbone._originalSync(method, model, options);
  };
})();
