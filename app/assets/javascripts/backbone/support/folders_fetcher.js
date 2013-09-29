Support.FoldersFetcher = function(folders, interval) {
  var self = this;
  self._folders = folders;

  self._fetchHandler = function() {
    self._folders.fetch({cache: false});
  };
  setInterval(self._fetchHandler, interval);
}
