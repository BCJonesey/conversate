Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    this.is_current = this.get('id') == Structural.Router.currentTopicId;

    this.is_unread = this.get('unread_conversations') > 0;
  }
});
