module AddressBookHelper
  # Public: Gets the address book for a user as an html safe string of option
  # tags.
  #
  # Note - currently ignores the user argument and returns all the users for the
  # entire application.  Fix this later.
  def address_book_options(user)
    User.all.collect { |u| "<option value=\"#{u.id}\">#{u.name}</option>" }
            .join('')
            .html_safe
  end
end
