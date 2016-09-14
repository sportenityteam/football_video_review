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

  def generate_mp4(video,video_url)
    puts "in method*************************************"
    if video_url.present? #&& video_url_file_name.split('.').last != "mp4"
      puts "in generate_mp4 if*************************************"
      filename = "media1#{Time.now.to_i}"
      movie = FFMPEG::Movie.new("#{video_url.path}")
      puts "=-----************#{movie.duration}***************************"
      #self.duration = movie.duration
      movie.transcode("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
      f                = File.open("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
      #self.video_url = f
      video.update_attribures(:duration => movie.duration, :video_url => f)
      f.close
      movie1 = FFMPEG::Movie.new("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
      File.delete("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
    end
  end

end
