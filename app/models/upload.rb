class Upload < ActiveRecord::Base
  # This method associates the attribute ":upload" with a file attachment
  has_attached_file :upload
end
