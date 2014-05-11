//= require ./collection_fetcher

Support.ContactsFetcher = Support.CollectionFetcher({
  interval: {min: 50000, max: 600000},
  success: function(){Structural._user.rebuildAddressBook()}
});
