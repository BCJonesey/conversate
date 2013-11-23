// TODO: This is eventually meant to be generic for all (or most) kinds of
// actions, but for now it only handles email_message ones.

Structural.Views.ActionDetails = Support.CompositeView.extend({
  className: 'act-details hidden',
  template: JST['backbone/templates/actions/details'],
  initialize: function(options) {

  },
  events:{
    'click .act-details-close':'hide'
  },
  render: function() {
    if (this.action) {
      this.$el.html(this.template({action: this.action}));
    }
  },

  show: function(action) {
    this.action = action;
    this.$el.removeClass('hidden');
    this.render();
  },
  hide:function(){
    this.$el.addClass('hidden');
  }
});
