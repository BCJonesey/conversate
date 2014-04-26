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
    return this.addressBook().hasOwnProperty(user_id);
  },
  rebuildAddressBook: function(){
    this.set("addressBook",this.buildAddressBook());
    this.trigger('addressBookUpdated');
  },
  buildAddressBook: function(){
    var retVal = {};
    if(Structural._contactLists.length != 0)
    {
      Structural._contactLists.each(function(cl){
        cl.get("contacts").each(function(contact){
          retVal[contact.get("user_id")] = {
            id: contact.get("user_id"),
            name: contact.escape("user").escape("name")
          }
        })
      });
    }
    return retVal;
  }
});

_.extend(Structural.Models.User.prototype, Support.InflatableModel);
