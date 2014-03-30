class Upload < ActiveRecord::Base
  # This method associates the attribute ":upload" with a file attachment
  has_attached_file :upload
  validates_attachment :upload,
    :content_type => { content_type: /.*/ },
    :size => { less_than: 1.kilobytes }

  attr_accessible :upload
end
