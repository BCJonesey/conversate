class Upload < ActiveRecord::Base
  # This method associates the attribute ":upload" with a file attachment
  has_attached_file :upload
  do_not_validate_attachment_file_type :upload

  attr_accessible :upload
end
