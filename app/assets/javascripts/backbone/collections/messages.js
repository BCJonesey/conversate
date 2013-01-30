ConversateApp.Collections.Messages = Backbone.Collection.extend({
  model: ConversateApp.Models.Message,
  url: function() {
    if (ConversateApp.opened_conversation) {
      return '/conversations/' + ConversateApp.opened_conversation
    }
    else {
      console.log("Collections.Messages: Can't return a url without an opened_conversation.");
    }
  }
});
