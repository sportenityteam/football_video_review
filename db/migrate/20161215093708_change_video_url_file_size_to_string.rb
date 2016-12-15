class ChangeVideoUrlFileSizeToString < ActiveRecord::Migration
  def change
    change_column :videos, :video_url_file_size, :integer, limit: 8
  end
end
