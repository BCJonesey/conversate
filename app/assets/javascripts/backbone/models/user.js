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
  addUserToAddressBook: function(user_id,user_name){
    this.addressBook()[user_id] = this.buildAddressBookEntry(user_id,user_name);
    this.trigger('addressBookUpdated');
  },
  buildAddressBookEntry: function(user_id,user_name){
    var entry =
    {
      id: user_id,
      name: user_name
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
          var id = contact.get('user_id');
          var name = contact.get('user').escape('name');
          retVal[contact.get("user_id")] = self.buildAddressBookEntry(id, name);
        })
      });
    }
    return retVal;
  }
});

_.extend(Structural.Models.User.prototype, Support.InflatableModel);
