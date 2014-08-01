Structural.Views.AddInviteDialog = Support.CompositeView.extend({
  className: 'contacts-add-invite-wrap popover-wrap',
  template: JST.template('people/contacts/add_invite_dialog'),
  initialize: function() {
    Structural.on('clickAnywhere', this.closeOnClickOff, this);
  },
  render: function() {
    this.$el.html(this.template({}));
    return this;
  },
  events: {
    'click .contacts-add-invite': 'toggleAddInvite',
    'click .popover-close': 'toggleAddInvite'
  },

  toggleAddInvite: function(e) {
    e.preventDefault();
    this.$('.contacts-add-invite-popover').toggleClass('hidden');
  },
  closeOnClickOff: function(e) {
    var target = $(e.target);
    if (target.closest('.contacts-add-invite-wrap').length === 0) {
      this.$('.contacts-add-invite-popover').addClass('hidden');
    }
  }
})
