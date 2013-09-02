namespace :reading_logs do

  desc 'Calculate the unread count per user per conversation and update' +
   'the appropriate reading log entry'
  task calculate_unread_count: [:environment] do
    User.all.each do |user|
      user.conversations.each do |conversation|
        puts user.name + ':' + conversation.id.to_s + ':' + conversation.title
      end
    end
  end

end
