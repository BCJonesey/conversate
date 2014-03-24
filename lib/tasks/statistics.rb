class Statistics
  def Statistics.run(users)
    all_stats = [
      :count,
      :count_conversations
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
end
