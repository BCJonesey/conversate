require 'spec_helper'

describe MandrillInboundEmail do
  let(:msg) {{"from_email"=>"test2@example.com","text"=>"message content","email"=>"cnv-22@kuhltank.watercooler.io","subject"=>"Test mail", "full_name" => "poop head"}}
  let(:data) { {"event"=>"inbound","msg"=>msg} }
  let(:convo) {"convo"}
  let(:user) {User.build(email: msg["from_email"], password: 'a')}
  let(:folder) {"folder"}
  let(:sender) {"sender"}

  describe 'initializer' do
    before :each do
      convo.stub(:id).and_return("22")
      Conversation.stub(:find).with(convo.id).and_return(convo)
      User.stub(:find_by_email_insensitive).and_return(nil)
      User.stub(:find_by_email_insensitive).with("test2@example.com").and_return(user)
    end

    after :each do
      MandrillInboundEmail.new(msg)
    end

    it 'looks up the user' do
      User.should_receive(:find_by_email_insensitive).with(msg["from_email"]).once
    end
    it 'creates the user if it does not exist' do
      msg["from_email"] = "killa_vanilla@poop.com"
      User.stub(:build).and_return(user)
      User.should_receive(:build).once
    end
    context 'inbound to folder' do
      it 'looks up the folder' do
        user.default_folder.update({:email => "folderz"})
        msg["email"]="folderz@watercooler.io"
        Folder.should_receive(:find_by_email_insensitive).with("folderz").once
      end
    end
    context 'inbound to conversation' do
      it "gets the correct conversation" do
        Conversation.should_receive(:find).with(convo.id).once
      end
    end
  end
end
