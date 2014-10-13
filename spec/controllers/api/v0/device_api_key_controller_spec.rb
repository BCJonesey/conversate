require "spec_helper"

describe Api::V0::DeviceApiKeyController do
  before(:all) do
    @user = User.create(email: 'device@example.com',
                        full_name: 'device',
                        password: 'a',
                        password_confirmation: 'a')
  end

  describe 'POST #create' do
    it 'successfully creates a device with valid credentials' do
      post :create, email: @user.email, password: 'a'

      expect(response).to be_success
      data = JSON.parse(response.body)

      expect(data['user_id']).to eq(@user.id)
      expect(data['device_api_key']).to be_a(String)

      device = Device.find_by_device_api_key(data['device_api_key'])
      expect(device).to be
    end

    it 'fails to create a device with invalid credentials' do
      post :create, email: @user.email, password: 'bad'

      expect(response).not_to be_success
      data = JSON.parse(response.body)

      expect(data['status']).to eq(401)
    end
  end
end
