namespace :folder do
  namespace :default do
    desc 'Create a default folder for each user that has none'
    task create: [:environment] do
      User.all.each do |user|
        if user.default_folder_id.nil?
          default_folder = Folder.new
          default_folder.name = 'My Conversations'
          default_folder.save
          user.default_folder_id = default_folder.id
          user.folders << default_folder
          user.save
        end
      end
    end

    desc 'Move all conversations into default folders'
    task populate: [:environment] do
      User.all.each do |user|
        default = Folder.find(user.default_folder_id)
        user.conversations.each do |conversation|
          conversation.folders << default
          conversation.save
        end
      end
    end
  end

  desc 'Change all update_topics actions to update_folders'
  task from_topics: [:environment] do
    Action.where(type: 'update_topics').each do |action|
      action.type = 'update_folders'
      action.save
    end
  end
end
