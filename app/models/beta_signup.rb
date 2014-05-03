class BetaSignup < ActiveRecord::Base
  attr_accessible :email

  def create_promoted_user
    password = garbage_password
    User.build({
      email: self.email,
      password: password,
      password_confirmation: password
    })
  end

  def create_welcome_conversation(user)
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
  end

  private

  def garbage_password
    SecureRandom.uuid
  end
end
