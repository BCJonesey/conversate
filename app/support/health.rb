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
    []
  end

  def Health.user_with_no_groups
    []
  end

  def Health.topic_with_no_users
    []
  end

  def Health.conversation_with_no_users
    []
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