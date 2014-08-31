Structural.Views.AddInviteDialog = Support.CompositeView.extend({
  className: 'contacts-add-invite-wrap popover-wrap',
  template: JST.template('people/contacts/add_invite_dialog'),
  initialize: function() {
    Structural.on('clickAnywhere', this.closeOnClickOff, this);
    this.showInviteInsteadOfOptions = false;
  },
  render: function() {
    this.$el.html(this.template({}));

    // Structural._user.addressBook() doesn't exist during initialize(), so
    // we have to create the autocomplete here.
    if (!this.autocomplete) {
      this.autocomplete = new Structural.Views.Autocomplete({
        dictionary: Structural._user.addressBook(),
        blacklist: new Structural.Collections.Participants([]),
        addSelectionToBlacklist: false,
        property: 'name',
        inputContainer: this.$('.contact-input'),
        optionsContainer: this.$('.contacts-list')
      });
      this.autocomplete.on('optionsUpdated', this.showInviteOnNoOptions, this);
      this.autocomplete.on('select', this.addExistingUser, this);
    }

    this.appendChild(this.autocomplete);
    this.showHideInviteContacts();

    return this;
  },
  events: {
    'click .contacts-add-invite': 'toggleAddInvite',
    'click .popover-close': 'toggleAddInvite',
    'click .invite-contact button': 'inviteContact',
    'click .add-contact button': 'addFoundUser'
  },

  toggleAddInvite: function(e) {
    if (e) { e.preventDefault(); }

    this.$('.contacts-add-invite-popover').toggleClass('hidden');
    if (this.$('.contacts-add-invite-popover').hasClass('hidden')) {
      this.$('.add-contact').addClass('hidden');
      this.$('.invite-contact').addClass('hidden');
      this.hideSpinner();
      this.hideError();
    }
  },
  closeOnClickOff: function(e) {
    var target = $(e.target);
    if (target.parents().length > 0 &&
        target.closest('.contacts-add-invite-wrap').length === 0) {
      this.close();
    }
  },
  close: function() {
    this.currentText = '';
    this.$('.contacts-add-invite-popover').addClass('hidden');
    this.$('.add-contact').addClass('hidden');
    this.$('.invite-contact').addClass('hidden');
    this.hideSpinner();
    this.hideError();
  },

  inviteContact: function(e) {
    e.preventDefault();

    var email = this.currentText;
    var invite = new Structural.Models.Invite({
      email: email
    });
    var contact = new Structural.Models.Contact({
      contact_list_id: Structural._selectedContactListId,
      user_id: undefined,
      user: {
        email: email,
        full_name: email,
        name: email
      }
    });

    invite.save({}, {
      success: function() {
        this._addContactToList(contact);
        this.close();
      }.bind(this),
      error: this.showError.bind(this)
    });
    this.showSpinner();
  },
  addExistingUser: function(user) {
    var newContact = new Structural.Models.Contact({
      contact_list_id: Structural._selectedContactListId,
      user_id: user.id,
      user: user
    });
    newContact.save({}, {
      success: this.close.bind(this),
      error: this.showError.bind(this)
    });
    this.showSpinner();
    this._addContactToList(newContact);
  },
  addFoundUser: function() {
    this.addExistingUser(this.foundUser);
  },

  _addContactToList: function(contact) {
    Structural._contactLists.get(Structural._selectedContactListId)
                            .get('contacts')
                            .add(contact);
    Structural._user.rebuildAddressBook();
  },

  searchForContactByEmail: _.debounce(function(email, found, notFound) {
    // This really doesn't correspond to a Backbone model, so we're dropping
    // down to raw ajax.
    $.ajax({
      url: Structural.Router.userLookupHref(email),
      dataType: 'json',
      context: this,
      success: function(data) {
        var user = new Structural.Models.Participant(data);
        found.call(this, user);
      },
      error: function() {
        notFound.call(this);
      }
    })
  }, 1000),

  showInviteOnNoOptions: function(options) {
    this.showInviteInsteadOfOptions = options.length === 0 &&
                                      this.autocomplete.text().length > 0;
    this.showHideInviteContacts();
  },
  showHideInviteContacts: function() {
    if (this.showInviteInsteadOfOptions) {
      if (this.currentText === this.autocomplete.text()) {
        return;
      }

      this.$('.contacts-list').addClass('hidden');
      this.currentText = this.autocomplete.text();
      this.showSpinner();
      this.$('.add-contact').addClass('hidden');
      this.$('.invite-contact').addClass('hidden');
      this.searchForContactByEmail(
        this.currentText,
        function(user) {
          this.hideSpinner();
          this.$('.add-contact button').text('Add ' + user.escape('name'));
          this.$('.contact-name').text(user.escape('name'));
          this.$('.contact-email').text(user.escape('email'));
          this.$('.add-contact').removeClass('hidden');
          this.$('.invite-contact').addClass('hidden');
          this.foundUser = user;
        },
        function() {
          this.hideSpinner();
          this.$('.invite-contact button').text('Invite ' + this.currentText);
          this.$('.add-contact').addClass('hidden');
          this.$('.invite-contact').removeClass('hidden');
        });
    } else {
      this.$('.contacts-list').removeClass('hidden');
      this.$('.invite-contact').addClass('hidden');
      this.$('.add-contact').addClass('hidden');
    }
  },
  showSpinner: function() {
    this.$('.spinner').removeClass('hidden');
  },
  hideSpinner: function() {
    this.$('.spinner').addClass('hidden');
  },
  showError: function() {
    this.hideSpinner();
    this.$('.error').removeClass('hidden');
  },
  hideError: function() {
    this.$('.error').addClass('hidden');
  }
})
