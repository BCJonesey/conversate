Structural.Models.User = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      if (this.get('full_name') && this.get('full_name').length > 0) {
        this.set('name', this.get('full_name'));
      } else {
        this.set('name', this.get('email'));
      }
    }
    this.inflateExtend(this.attributes);
  },

  inflateAttributes: function(attrs) {
    return attrs;
  },
  addressBook: function(){
    return this.get("addressBook") === undefined ? [] : this.get("addressBook");
  },
  knowsUser: function(user_id){
    return user_id == this.id || this.addressBook().hasOwnProperty(user_id);
  },
  rebuildAddressBook: function(){
    this.set("addressBook",this.buildAddressBook());
    this.trigger('addressBookUpdated');
  },
  addUserToAddressBook: function(user){
    this.addressBook()[user.id] = this.buildAddressBookEntry(user);
    this.trigger('addressBookUpdated');
  },
  buildAddressBookEntry: function(user){
    var entry =
    {
      id: user.id,
      name: user.escape('name'),
      email: user.escape('email')
    };
    return entry;
  },
  buildAddressBook: function(){
    var retVal = {};
    var self = this;
    if(Structural._contactLists.length != 0)
    {
      Structural._contactLists.each(function(cl){
        cl.get("contacts").each(function(contact){
          var user = contact.get('user');
          retVal[user.id] = self.buildAddressBookEntry(user);
        })
      });
    }
    return retVal;
  }
});

_.extend(Structural.Models.User.prototype, Support.InflatableModel);
