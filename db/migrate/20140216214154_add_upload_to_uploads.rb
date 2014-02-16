class AddUploadToUploads < ActiveRecord::Migration
  def self.up
    add_attachment :uploads, :upload
  end

  def self.down
    remove_attachment :uploads, :upload
  end
end
