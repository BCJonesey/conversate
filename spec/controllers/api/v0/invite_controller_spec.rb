require 'spec_helper'

describe Api::V0::InviteController do

  context "create" do

    it "should be able to make an invite" do
      post :create
      binding.pry
    end

  end

end
