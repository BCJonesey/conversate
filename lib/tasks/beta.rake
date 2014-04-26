namespace :beta do
  desc 'Promote a beta signup to a real user'
  task :promote, [:email] => [:environment] do |t, args|
    signup = BetaSignup.find_by_email(args[:email])
    if signup
      puts "Promoting #{args[:email]} to a real user"
    else
      puts "#{args[:email]} does not match anyone who signed up for the beta."
    end
  end
end
