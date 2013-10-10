//= require ./collection_fetcher

Support.FoldersFetcher = Support.CollectionFetcher({
  interval: {min: 30000, max: 300000}
});
