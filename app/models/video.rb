class Video < ActiveRecord::Base
  #associations
  belongs_to :order

  #paperclip
  has_attached_file :video_url,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
                    #:default_url => "missing_user.png",
                    #:styles => { :medium => "300x300>", :thumb => "100x100>" }

  #validations
  validates_attachment_content_type :video_url, :content_type => /\Avideo\/.*\Z/
  validates :video_url, :presence => true

  def generate_mp4(video)
    if video.present?
      if video.video_url.present? && video.video_url_file_name.split('.').last != "mp4"
        filename = "media1#{Time.now.to_i}"
        if File.exists?"#{video.video_url.path}"
          movie = FFMPEG::Movie.new("#{video.video_url.path}")
          movie.transcode("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
          f = File.open("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
          video.duration = movie.duration
          video.video_url = f
          video.save
          f.close
          movie1 = FFMPEG::Movie.new("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
          File.delete("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        end
      end
    end
  end

end