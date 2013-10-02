Support.CollectionFetcher = function(interval, event, collFunc) {
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
    setInterval(self._fetchHandler, interval);

    if (event) {
      Structural.on(event, function(eventArg) {
        self._collection = collFunc(eventArg);
      });
    }
  };
};
