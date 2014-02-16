require 'spec_helper'

describe Upload do
  it "directly describes a file", :focus => true do
    upload_file = fixture_file_upload('/files/scream.jpeg', 'image/jpeg')
    file = Upload.new(:upload => upload_file)
    expect(file.upload.name).to eq('banzai')
  end
end
