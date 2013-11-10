require 'mandrill'

class EmailWorker
  SLEEP = 5

  def initialize(options={})
    @verbose = !!options[:verbose]
    @exit = false
  end

  def start
    log 'starting'

    trap('TERM') { log 'terminated'; @exit = true }
    trap('INT') { log 'interrupted'; @exit = true }

    loop do
      pending_emails = EmailQueue.all

      if pending_emails.count == 0
        sleep SLEEP
      else
        pending_emails.each do |email|
          user = User.find(email.external_user_id)
          action = Action.find(email.action_id)
          conversation = action.conversation
          log "sending email to #{user.email}: action ##{action.id}"
          EmailQueue.delete email
          response = send_email user, action, conversation
          log "response from #{user.email} for action ##{action.id}: #{response}"
          # TODO: Handle errors in delivery

          break if @exit
        end
      end

      break if @exit
    end
  end

  def send_email(user, action, conversation)
  end

  def log(text)
    puts "EMAIL WORKER: #{text}" if @verbose
  end
end
