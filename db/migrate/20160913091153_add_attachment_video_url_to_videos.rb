class AddAttachmentVideoUrlToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.attachment :video_url
    end
  end

  def self.down
    remove_attachment :videos, :video_url
  end
end
