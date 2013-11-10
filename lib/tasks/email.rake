namespace :email do
  namespace :worker do
    desc 'Starts an email worker that reads from the email queue'
    task start: [:environment] do
      worker = EmailWorker.new verbose: true
      worker.start
    end
  end
end
