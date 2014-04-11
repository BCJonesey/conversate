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
    this.contactLists = new Structural.Collections.ContactLists();
    this.contactsFetcher = new Support.ContactsFetcher(this.contactLists);
  },

  inflateAttributes: function(attrs) {
    return attrs;
  },
  addressBook: function(){
    return Structural._user.get("addressBook") === undefined ? [] : Structural._user.get("addressBook");
  },
  knowsUser: function(user_id){
    return _.indexOf(this.addressBook(), user_id) > -1;
  },
  rebuildAddressBook: function(){
    this.set("addressBook",this.buildAddressBook());
  },
  buildAddressBook: function(){
    if(Structural._contactLists.length == 0)
    {
      return [];
    }
    return _.flatten(Structural._contactLists.map(function(cl){return cl.get("contacts").map(function(x){return x.get("user_id")})}));
  }
});

_.extend(Structural.Models.User.prototype, Support.InflatableModel);
