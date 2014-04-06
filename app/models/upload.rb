class Upload < ActiveRecord::Base
  # This method associates the attribute ":upload" with a file attachment
  has_attached_file :upload
  validates_attachment :upload,
    :content_type => { content_type: /.*/ },
    :size => { less_than: 10.megabytes }

  attr_accessible :upload
end
