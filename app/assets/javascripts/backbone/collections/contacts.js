Structural.Collections.Contacts = Backbone.Collection.extend({
  model: Structural.Models.Contact,
  url: function() {
    return Structural.apiPrefix + '/contact_lists/' + this.contactListId + '/contacts';
  }
})
