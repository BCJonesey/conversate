class Statistics
  def Statistics.run(users)
    all_stats = [
      :count,
      :count_conversations,
      :conversation_length,
      :user_chattiness
    ]

    all_stats.each do |stat|
      Statistics.send(stat, users)
      puts
    end
  end

  def Statistics.count(users)
    puts "Total users: #{users.count}"
  end

  def Statistics.count_conversations(users)
    convo_counts = users.map{|u| u.conversations.count }.sort
    median = convo_counts[convo_counts.count / 2]

    puts "Most conversations:   #{convo_counts.last}"
    puts "Median conversations: #{median}"
    puts "Fewest conversations: #{convo_counts.first}"
  end

  def Statistics.conversation_length(users)
    action_counts = users.map{|u| u.conversations }
                         .flatten
                         .uniq
                         .map{|c| c.actions.count }
                         .sort
    median = action_counts[action_counts.count / 2]

    puts "Longest conversation:  #{action_counts.last}"
    puts "Median conversation:   #{median}"
    puts "Shortest conversation: #{action_counts.first}"
  end

  def Statistics.user_chattiness(users)
    message_counts = users.map{|u| u.actions.keep_if{|a| a.message_type? }.count }
                          .sort
    median = message_counts[message_counts.count / 2]

    puts "Chattiest user: #{message_counts.last} messages"
    puts "Median user:    #{median} messages"
    puts "Laconic user:   #{message_counts.first} messages"
  end
end
