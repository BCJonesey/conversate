require 'spec_helper'

describe Invite do

  context "email validations" do
    let (:invite) {
      invite = Invite.new
      invite.user_id = 1
      invite
    }

    it "should not allow a nil email" do
      invite.valid?.should_not be_true
    end

    it "should not allow a blank email" do
      invite.email = ""
      invite.valid?.should_not be_true
    end

    it "should allow a email with one @" do
      invite.email = "blahrg@example.com"
      invite.valid?.should be_true
    end
  end

  context "user_id validations" do
    let (:invite) {
      invite = Invite.new
      invite.email = "blah@example.com"
      invite
    }

    it "should not allow a nil user_id" do
      invite.valid?.should_not be_true
    end

    it "should allow an integer user_id" do
      invite.user_id = 1
      invite.valid?.should be_true
    end

  end

end
