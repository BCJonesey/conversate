Support.CollectionFetcher = function(interval, event, collFunc) {
  return function(initialCollection) {
    var self = this;
    self._collection = initialCollection;

    self._fetchHandler = function() {
      self._collection.fetch({cache: false});
    };
    setInterval(self._fetchHandler, interval);

    if (event) {
      Structural.on(event, function(eventArg) {
        self._collection = collFunc(eventArg);
      });
    }
  };
};
