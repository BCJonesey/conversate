namespace :db do
  desc 'Finds any stray user_update actions and fixes them.'
  task user_update_fix: [:environment] do
    count = 0
    Action.where(type: 'user_update').each do |action|
      action.type = 'update_users'
      action.save
      count += 1
    end

    if count == 0
      puts 'There were no bad actions in your database.'
    else
      puts "Fixed #{count} actions with the wrong type."
    end
  end
end
