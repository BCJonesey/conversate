//= require ./collection_fetcher

Support.ConversationsFetcher = Support.CollectionFetcher({
  interval: 60000,
  event: 'changeFolder',
  collFunc: function(folder) {
    return folder.conversations;
  }
});
