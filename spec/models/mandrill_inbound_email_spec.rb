require 'spec_helper'

describe MandrillInboundEmail do
  let(:msg) {{"from_email"=>"test2@example.com","text"=>"message content","email"=>"cnv-22@kuhltank.watercoolr.io","subject"=>"Test mail"}}
  let(:data) { {"event"=>"inbound","msg"=>msg} }
  describe 'initializer' do
    it 'looks up the user' do
      #true
    end
    it 'creates the user if it does not exist' do
      #true
    end
    context 'inbound to folder' do
      it 'looks up the folder' do
        #do a thing
      end
      it 'creates conversation' do
        #it
      end
      it 'sets title' do
        #end
      end
      it 'adds participant' do
        #yar
      end
      it 'calls dispatch_to_conversation' do
        #do eeeet
      end
    end
    context 'inbound to conversation' do
      it "gets the correct conversation" do
        #ff
      end
    end
  end
end