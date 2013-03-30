require "spec_helper"

describe Api::V0::ParticipantsController do

  describe 'GET #index' do
    it 'successfully responds with all of the participants in the current conversation'
    it 'unsuccessfully responds when the conversation does not exist'
  end

  describe 'POST #create' do
    it 'successfully creates a participants in a specified conversation'
    it 'unsuccessfully creates when the conversation does not exist'
  end

  describe 'DELETE #destroy' do
    it 'successfully removes a specified participant from a specified conversation'
    it 'unsuccessfully removes a participant when the conversation does not exist'
    it 'unsuccessfully removes a participant when the participant does not exist.'
  end
end
