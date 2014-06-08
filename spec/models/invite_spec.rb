require 'spec_helper'

describe Invite do

  let (:invite) {Invite.new}

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
