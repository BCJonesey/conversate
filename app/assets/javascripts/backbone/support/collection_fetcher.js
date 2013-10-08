Support.CollectionFetcher = function(options) {
  return function(initialCollection) {
    var self = this;
    self._collection = initialCollection;
    self._waitingOnRequest = false;

    self._requestFinished = function() {
      self._waitingOnRequest = false;
    };

    self._fetchHandler = function() {
      if (!self._waitingOnRequest) {
        self._collection.fetch({
          cache: false,
          success: self._requestFinished,
          error: self._requestFinished
        });
        self._waitingOnRequest = true;
      }
    };
    setInterval(self._fetchHandler, options.interval);

    if (options.event) {
      Structural.on(options.event, function(eventArg) {
        self._collection = options.collFunc(eventArg);
      });
    }
  };
};
