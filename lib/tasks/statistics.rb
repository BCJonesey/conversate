class Statistics
  def Statistics.run(users)
    all_stats = [
      :count
    ]

    all_stats.each do |stat|
      Statistics.send(stat, users)
    end
  end

  def Statistics.count(users)
    puts "Total users: #{users.count}"
  end
end
