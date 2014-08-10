require 'spec_helper'

describe Invite do


  context "user validations" do
    let (:invite) {
      invite = Invite.new
      invite.inviter_id = 3
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

  context "inviter validations" do
    let (:invite) {
      invite = Invite.new
      invite.user_id = 3
      invite
    }

    it "should not allow a nil inviter_id" do
      invite.valid?.should_not be_true
    end

    it "should allow an integer user_id" do
      invite.inviter_id = 1
      invite.valid?.should be_true
    end

  end

end
