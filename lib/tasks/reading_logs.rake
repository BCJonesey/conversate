namespace :reading_logs do

  desc 'Calculate the unread count per user per conversation and update' +
   'the appropriate reading log entry'
  task calculate_unread_count: [:environment] do
    User.all.each do |user|
      user.conversations.each do |conversation|

        # Get the relevant reading_log entry.
        reading_log = ReadingLog.where(:user_id => user.id, :conversation_id => conversation.id).first

        # Check for a null most_recent_viewed. If so, let's make it now and update.
        if (reading_log.most_recent_viewed.nil?)
          reading_log.most_recent_viewed = DateTime.now
        end

        # Calculate the unread count to insert into this reading log.
        reading_log.unread_count = calculate_unread_count(conversation, reading_log)

        # Now we can save the reading log, and our user's unread_count will be correct as of now.
        reading_log.save

        # Let's print out the details of each update for sanity checking when
        # running this.
        puts reading_log.unread_count.to_s + ' ' + user.name + ':' + conversation.id.to_s + ':' + conversation.title
      end
    end
  end

end

# Calculates the unread count for a given conversation and indirectly, a user through their reading log.
def calculate_unread_count(conversation, reading_log)
  unread_count = 0
  conversation.actions.each do |action|
    if (action.created_at > reading_log.most_recent_viewed)
      unread_count += 1
    end
  end

  return unread_count

end
