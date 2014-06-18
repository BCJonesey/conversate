Structural.Models.ContactList = Backbone.Model.extend({
  urlRoot: function() {return Structural.apiPrefix + "/contact_lists"},
  initialize: function(attributes, options) {
    var self = this;
    this.inflateExtend(this.attributes);
  },
  parse: function (response, options) {
    return this.inflateReturn(response);
  },
  inflateAttributes: function(attrs) {
    if (attrs.contacts) {
      attrs.contacts = this.inflate(Structural.Collections.Contacts,attrs.contacts);
    }
    return attrs;
  },

  show: function() {
    if (Structural._selectedContactListId != this.id) {
      Structural._selectedContactListId = this.id;

      // This can sometimes be called during the initialization of the _people
      // object, in which case there's nothing to trigger off of.  Fortunately,
      // it also means that nothing else could have a reference to _people to
      // listen to it yet, so we can safely drop this trigger on the floor.
      if (Structural._people) {
        Structural._people.trigger('switchContactList');
      }
    }
  }
});

_.extend(Structural.Models.ContactList.prototype, Support.InflatableModel);
