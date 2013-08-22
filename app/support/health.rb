module Health
  def Health.user_with_nil_default_topic
    User.where(:default_topic_id => nil).map do |u|
      {
        :model => u,
        :notes => u.topics.map{|t| t.debug_s}.join(', ')
      }
    end
  end

  def Health.user_with_no_topics
    User.all.keep_if {|u| u.topics.empty? }.map do |u|
      {
        :model => u,
        :notes => ''
      }
    end
  end

  def Health.user_with_no_groups
    User.all.keep_if {|u| u.groups.empty? }.map do |u|
      {
        :model => u,
        :notes => ''
      }
    end
  end

  def Health.topic_with_no_users
    Topic.all.keep_if {|t| t.users.empty? }.map do |t|
      {
        :model => t,
        :notes => ''
      }
    end
  end

  def Health.conversation_with_no_users
    Conversation.all.keep_if {|c| c.users.empty? }.map do |c|
      {
        :model => c,
        :notes => ''
      }
    end
  end

  def Health.conversation_with_no_topics
    []
  end

  def Health.group_with_no_admins
    []
  end

  def Health.group_with_no_users
    []
  end
end