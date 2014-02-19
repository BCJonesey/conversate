Structural.Models.Participant = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      if (this.get('full_name') && this.get('full_name').length > 0) {
        this.set('name', this.get('full_name'));
      } else {
        this.set('name', this.get('email'));
      }
    }
    if(Structural._user && Structural._user.get("address_book")){
		this.set('known',Structural._user.id == this.id || Structural._user.get("address_book").get(this.id) !== undefined);
    } else{
    	this.set('known',false);
    }
  }
});
