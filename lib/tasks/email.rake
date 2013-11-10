namespace :email do
  namespace :worker do
    desc 'Starts an email worker that reads from the email queue'
    task start: [:environment] do
    end
  end
end
