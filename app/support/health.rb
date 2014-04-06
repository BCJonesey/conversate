# Methods in this module will get automatically executed for the site admin
# page.  Each method should follow some basic rules for best results:
#   - The method name should describe the problem it finds using a singular
#     reference to the model it finds it on.
#   - The method should return an array of hashes with two keys:
#       :model should be the model object that exhibits the error.
#       :notes should be a string with any additionaly information useful in
#              fixing the problem.
module Health

  # User health checks

  def Health.user_with_nil_default_folder
    User.where(:default_folder_id => nil).map do |u|
      {
        :model => u,
        :notes => u.folders.map{|t| t.debug_s}.join(', ')
      }
    end
  end

  def Health.user_with_no_folders
    User.all.keep_if {|u| u.folders.empty? }.map do |u|
      {
        :model => u,
        :notes => ''
      }
    end
  end

  # Disabled due to all email-created users having no groups by design.

  # def Health.user_with_no_groups
  #   User.all.keep_if {|u| u.groups.empty? }.map do |u|
  #     {
  #       :model => u,
  #       :notes => ''
  #     }
  #   end
  # end

  # Folder health checks

  def Health.folder_with_no_users
    Folder.all.keep_if {|t| t.users.empty? }.map do |t|
      {
        :model => t,
        :notes => ''
      }
    end
  end

  # Conversation health checks

  def Health.conversation_with_no_users
    Conversation.all.keep_if {|c| c.users.empty? }.map do |c|
      {
        :model => c,
        :notes => ''
      }
    end
  end

  def Health.conversation_with_duplicate_users
    Conversation.all.keep_if {|c| c.users.length != c.users.uniq.length }.map do |c|
      {
        :model => c,
        :notes => c.users.keep_if {|u| c.users.index(u) != c.users.rindex(u) }.uniq.map {|u| u.debug_s }.join(', ')
      }
    end
  end

  def Health.conversation_with_no_folders
    Conversation.all.keep_if {|c| c.folders.empty? }.map do |c|
      {
        :model => c,
        :notes => ''
      }
    end
  end

  def Health.conversation_hidden_from_users
    hidden_users_by_convo = {}
    Conversation.all.keep_if do |c|
      c_folders = Set.new(c.folders)
      hidden_from = c.users.keep_if do |u|
        Set.new(u.folders).intersection(c_folders).empty?
      end
      hidden_users_by_convo[c] = hidden_from
      hidden_from.length > 0
    end.map do |c|
      {
        :model => c,
        :notes => hidden_users_by_convo[c].map {|u| u.debug_s }.join(', ')
      }
    end
  end

  def Health.conversation_with_bogus_date
    # We didn't have a water cooler server in Jan 2013
    Conversation.where('most_recent_event < ?', Date.new(2013)).map do |c|
      {
        :model => c,
        :notes => ''
      }
    end
  end

  # This one is looking for conversations that are in a folder but don't have
  # anyone participating on the conversation that are participating in that
  # folder.
  #
  # Disabled due to conversations initiated by email not adding users.

  # def Health.conversation_with_no_participants_in_folder
  #   bad_folders = {}
  #   Conversation.all.keep_if do |c|
  #     c_set = c.users.to_set
  #     c.folders.each do |f|
  #       f_set = f.users.to_set
  #       if c_set.intersection(f_set).empty?
  #         bad_folders[c] = bad_folders.fetch(c, []).push(f)
  #       end
  #     end
  #     bad_folders.has_key? c
  #   end.map do |c|
  #     {
  #       :model => c,
  #       :notes => bad_folders.fetch(c, []).map{|f| f.debug_s }.join(', ')
  #     }
  #   end
  # end

  # Group health checks

  def Health.group_with_no_admins
    Group.all.keep_if {|g| g.admins.empty? }.map do |g|
      {
        :model => g,
        :notes => g.users.map {|u| u.debug_s }.join(', ')
      }
    end
  end

  def Health.group_with_no_users
    Group.all.keep_if {|g| g.users.empty? }.map do |g|
      {
        :model => g,
        :notes => ''
      }
    end
  end
end
