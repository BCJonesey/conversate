namespace :beta do
  desc 'Promote a beta signup to a real user'
  task :promote, [:email] => [:environment] do |t, args|
    signup = BetaSignup.find_by_email(args[:email])
    if signup
      puts "Promoting #{args[:email]} to a real user"
      user = signup.create_promoted_user

      unless user
        puts "Failed to build user for promotion."
        next
      end

      signup.delete
      puts "Promotion succeeded."
    else
      puts "#{args[:email]} does not match anyone who signed up for the beta."
    end
  end
end
