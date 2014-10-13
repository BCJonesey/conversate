class Device < ActiveRecord::Base
  belongs_to :user

  def self.new_device_for(user)
    d = Device.new
    d.user_id = user.id
    d.device_api_key = SecureRandom.uuid
    d.save

    d
  end

  def as_json(options={})
    super(:only => [:user_id, :device_api_key])
  end
end
