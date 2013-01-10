module AddressBookHelper
  # Public: Gets the address book for a user as an html safe string of option
  # tags.
  #
  # Note - currently ignores the user argument and returns all the users for the
  # entire application.  Fix this later.
  def address_book_options(user)
    user.address_book.collect { |u| "<option value=\"#{u.id}\">#{u.name}</option>" }
                     .join('')
                     .html_safe
  end

  # Public: Gets the json tokens for a set of users.
  #
  # Returns a json string like "[{'id': 1, 'name': 'James'}, ...]"
  def user_tokens_json(users)
    users.collect {|u| {'id' => u.id, 'name' => u.name} }.to_json.html_safe
  end
end
