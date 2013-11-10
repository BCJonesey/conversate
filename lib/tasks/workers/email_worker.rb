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
    message = {
      subject: conversation.title,
      text: action.text,
      from_email: action.user.email,
      from_name: action.user.full_name,
      to: [
        {
          email: user.email,
          name: user.full_name,
          type: 'to'
        }
      ],
      headers: {
        'Reply-To' => "#{conversation.title} <#{conversation.email_address}>"
      }
    }

    # It looks like we need to make a new API instance every time we do stuff
    # with the Mandrill API.  My best guess is that it's because it holds onto
    # a session object instead of making a new one each request.  See
    # https://bitbucket.org/mailchimp/mandrill-api-ruby/src/03e3e28e77dcba31eab7d2f9e2216b5a01d2110d/lib/mandrill.rb?at=master
    #
    # Note also that you need to the set the environment variable
    # MANDRILL_APIKEY before running this
    mandrill = Mandrill::API.new
    mandrill.messages.send message
  end

  def log(text)
    puts "EMAIL WORKER: #{text}" if @verbose
  end
end
