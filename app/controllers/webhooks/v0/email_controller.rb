class Webhooks::V0::EmailController < ApplicationController
  def mandrill_inbound
    begin
      events = JSON.parse(params[:mandrill_events])
      events.keep_if {|e| e['event'] == 'inbound' }
            .map {|e| MandrillInboundEmail.new(e['msg']) }
            .each do |email|
              if email.to_conversation?
                email.dispatch_to_conversation
              else
                # TODO: Send emails to folders
              end
            end
    rescue
      render text: $!.to_s + '\n\n'
    else
      render nothing: true
    end
  end
end
