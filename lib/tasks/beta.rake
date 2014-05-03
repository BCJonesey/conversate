namespace :beta do
  def garbage_password
    SecureRandom.uuid
  end

  desc 'Promote a beta signup to a real user'
  task :promote, [:email] => [:environment] do |t, args|
    signup = BetaSignup.find_by_email(args[:email])
    if signup
      puts "Promoting #{args[:email]} to a real user"

      password = garbage_password
      user = User.build({
        email: args[:email],
        password: password,
        password_confirmation: password
      })

      unless user
        puts "Failed to build user for promotion."
        next
      end

      support = User.find(122)
      welcome_convo = user.default_folder.conversations.create(title: 'Hello')
      action_params = [
        { 'type' => 'retitle',
          'title' => 'Hello'
        },
        { 'type' => 'update_users',
          'added' => [{id: support.id, full_name: support.full_name},
                      {id: user.id, full_name: user.full_name}],
          'removed' => nil
        },
        { 'type' => 'message',
          'text' => 'Hey this is support.  Are you supported?'
        }
      ]
      action_params.each do |params|
        action = welcome_convo.actions.create({
          type: params['type'],
          data: Action.data_for_params(params),
          user_id: support.id
        })
        action.save
        welcome_convo.handle(action)
      end
      welcome_convo.most_recent_event = welcome_convo.actions.last.created_at
      welcome_convo.save

      signup.delete
      puts "Promotion succeeded."
    else
      puts "#{args[:email]} does not match anyone who signed up for the beta."
    end
  end
end
