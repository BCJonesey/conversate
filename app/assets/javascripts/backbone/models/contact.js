Structural.Models.Contact = Backbone.Model.extend({
  urlRoot: function() {return Structural.apiPrefix + "/contact_lists/"+this.get("contact_list_id")+"/contacts"}
});