class Webhooks::V0::EmailController < ApplicationController
  def mandrill_inbound
    begin
      events = JSON.parse(params[:mandrill_events])
      events.keep_if {|e| e['event'] == 'inbound' }
            .map {|e| MandrillInboundEmail.new(e['msg']) }
            .each do |email|
              email.dispatch
            end
    rescue
      logger.error $!.to_s
      render text: $!.to_s + '\n\n'
    else
      render nothing: true
    end
  end
end
