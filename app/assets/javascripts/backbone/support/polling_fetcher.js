Support.PollingFetcher = function(interval, event, objFunc) {
  return function(initialObj) {
    var self = this;
    self._object = initialObj;
    self._waitingOnRequest = false;

    self._requestFinished = function() {
      self._waitingOnRequest = false;
    };

    self._fetchHandler = function() {
      if (!self._waitingOnRequest) {
        self._object.fetch({
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
        self._object = objFunc(eventArg);
      });
    }
  };
}
