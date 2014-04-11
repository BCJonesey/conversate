Structural.Models.Contact = Backbone.Model.extend({
	urlRoot: function() {return Structural.apiPrefix + "/contact_lists/"+this.get("contact_list_id")+"/contacts"},
	initialize: function(attributes, options) {
    	var self = this;
    	this.inflateExtend(this.attributes);
    },
    parse: function (response, options) {
    	return this.inflateReturn(response);
  	},
	inflateAttributes: function(attrs) {
	    if (attrs.user) {
	      attrs.user = this.inflate(Structural.Models.Participant,
	                                 attrs.user);
	    }
	    return attrs;
	}
});

_.extend(Structural.Models.Contact.prototype, Support.InflatableModel);