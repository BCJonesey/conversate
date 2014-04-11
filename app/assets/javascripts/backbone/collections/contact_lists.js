Structural.Collections.ContactLists = Backbone.Collection.extend({
  model: Structural.Models.ContactList,
  url: function() {
    return Structural.apiPrefix + '/users/' + Structural._user.id + '/contact_lists';
  }
})
