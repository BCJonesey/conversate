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

    process_queue_forever
  end

  def process_queue_forever
    loop do
      pending_emails = EmailQueue.all

      if pending_emails.empty?
        sleep SLEEP
      else
        pending_emails.each do |email|
          EmailQueue.delete email
          send_email email
          break if @exit
        end
      end

      break if @exit
    end
  end

  def construct_message(user, action, conversation)
    email_renderer = EmailRenderer.new(conversation, user)
    return {
      subject: "Re: #{conversation.title}",
      text: email_renderer.render(:text),
      html: email_renderer.render(:html),
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
  end

  def report_error(user, action, conversation, description)
    error_action = conversation.actions.create(
      type: 'email_delivery_error',
      user_id: action.user.id,
      data: { recipient: user,
              message: action,
              description: description }.to_json)
    log "error action created: #{error_action.id}"
  end

  def send_email(email)
    user = User.find(email.external_user_id)
    action = Action.find(email.action_id)
    conversation = action.conversation
    message = construct_message(user, action, conversation)

    begin
      # It looks like we need to make a new API instance every time we do stuff
      # with the Mandrill API.  My best guess is that it's because it holds onto
      # a session object instead of making a new one each request.  See
      # https://bitbucket.org/mailchimp/mandrill-api-ruby/src/03e3e28e77dcba31eab7d2f9e2216b5a01d2110d/lib/mandrill.rb?at=master
      #
      # Note also that you need to the set the environment variable
      # MANDRILL_APIKEY before running this
      mandrill = Mandrill::API.new

      log "sending email to #{message[:to][0][:email]}: action ##{email.action_id}"
      response = mandrill.messages.send message
      log "response from #{message[:to][0][:email]} for action ##{email.action_id}: #{response}"

      # Since we're mapping a single conversation to a single email, we should
      # only be sending one email at a time here, so we can assume Mandrill's
      # response will only have one hash.
      response = response.first

      unless response['status'] == 'sent' && response['reject_reason'].nil?
        report_error(user, action, conversation, error_description(response))
      end
    rescue Exception
      log "exception sending mail: #{$!}"
      report_error(user, action, conversation, error_description())
    rescue StandardError
      log "exception sending mail: #{$!}"
      report_error(user, action, conversation, error_description())
    end
  end

  def error_description(response={})
    "Error description:
  Response from mandrill: #{response}
  Exception: #{$!}
  Backtrace: #{$!.backtrace}"
  end

  def log(text)
    puts "EMAIL WORKER: #{text}" if @verbose
  end
end
