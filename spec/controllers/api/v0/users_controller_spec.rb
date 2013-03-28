require "spec_helper"

describe Api::V0::UsersController do

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
    end
  end

end
