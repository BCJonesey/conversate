//= require ./collection_fetcher

Support.ConversationsFetcher = Support.CollectionFetcher({
  interval: {min: 30000, max: 300000},
  event: 'changeFolder',
  collFunc: function(folder) {
    return folder.conversations;
  }
});
