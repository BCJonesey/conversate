namespace :migrate do
  namespace :search do
    desc "Compute initial search vectors for actions"
    task actionvectors: [:environment] do
      conn = ActiveRecord::Base.connection
      Action.all.each do |action|
        next unless action.type == 'message'

        text = conn.quote(action.text)
        conn.execute("
          update actions
          set search_vector = to_tsvector('english', #{text})
          where id = #{action.id}
          ")
      end
    end
  end
  namespace :contacts do
    desc "Crates default contact lists for all users"
    task create_default_lists: [:environment] do
      User.where(:default_contact_list_id => nil).each do |user|
        new_contact_list = ContactList.new
        new_contact_list.name = "My Contact List"
        if new_contact_list.save
          user.default_contact_list_id = new_contact_list.id
          puts("User id: #{user.id} failed to save with new contact list id: #{new_contact_list.id}") unless user.save
        else
          puts("failed to create a contact list for user id: #{user.id}")
        end
      end
    end
    desc "Moves all group contacts into peoples default contact list"
    task groups_to_contact_lists: [:environment] do
      User.all.each do |curr_user|
        curr_user.default_contact_list.contacts << curr_user.groups.map{|g| g.users}.flatten.uniq{|user| user.id}.reject{|user| user.id == curr_user.id}.map{|user| user.contacts.build}
      end
    end
  end
end
