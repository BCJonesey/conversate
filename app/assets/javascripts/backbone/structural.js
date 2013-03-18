#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require ./support/support

var Structural = new (Backbone.View.extend({
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  initialize: function(options) {
    this.apiPrefix = options.apiPrefix;
  },
  start: function(bootstrap) {
    // TODO: start app.
  }
}))({el: $('body'), apiPrefix: '/api/v0'});
