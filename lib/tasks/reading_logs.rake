namespace :reading_logs do

  desc 'Calculate the unread count per user per conversation and update' +
   'the appropriate reading log entry'
  task calculate_unread_count: [:environment] do
    User.all.each do |user|
      user.conversations.each do |conversation|

        # Get the relevant reading_log entry.
        reading_log = ReadingLog.where(:user_id => user.id, :conversation_id => conversation.id).first

        # Calculate the unread count to insert into this reading log.
        reading_log.unread_count = calculate_unread_count(user, conversation)

        # Let's print out the details of each update for sanity checking when
        # running this.
        puts reading_log.unread_count.to_s + ' ' + user.name + ':' + conversation.id.to_s + ':' + conversation.title
      end
    end
  end

end

def calculate_unread_count(user, conversation)
  return 15
end
