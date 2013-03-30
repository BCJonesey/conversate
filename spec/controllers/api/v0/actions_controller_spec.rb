require "spec_helper"

describe Api::V0::ActionsController do

  describe 'GET #index' do
    it 'successfully responds with a list of actions for a specified conversation'
    it 'responds unsuccessfully when the conversation does not exist'
  end

  describe 'POST #create' do
    it 'successfully creates a new action in the specified conversation'
  end

end
