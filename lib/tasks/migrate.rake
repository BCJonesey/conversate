namespace :migrate do
  namespace :search do
    desc "Compute initial search vectors for actions"
    task actionvectors: [:environment] do
      conn = ActiveRecord::Base.connection
      Action.all.each do |action|
        next unless action.type == 'message'

        text = conn.quote(action.text)
        conn.execute("
          update actions
          set search_vector = to_tsvector('english', #{text})
          where id = #{action.id}
        ")
      end
    end
  end

  namespace :email do
    desc 'Converts send_me_mail into email_setting'
    task send_me_mail_to_email_setting: [:environment] do
      User.all.each do |user|
        if user.send_me_mail
          user.email_setting = 'always'
          user.save
        end
      end
    end
  end
end
