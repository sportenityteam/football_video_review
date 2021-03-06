class Video < ActiveRecord::Base
  #associations
  belongs_to :order

  #paperclip
  has_attached_file :video_url,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename",
                    :styles => {
                                #:medium => { :geometry => "800x400<", :format => 'mp4' },
                                :thumb1 => { :geometry => "120x120#", :format => 'jpg', :time => 1 },
                                :thumb => { :geometry => "512x512#", :format => 'jpg', :time => 1 }
                               }, :processors => [:transcoder]

  #process_in_background :video_url

  #validations
  validates_attachment_content_type :video_url, :content_type => ['video/avi', 'video/example', 'video/mpeg', 'video/mp4', 'video/ogg', 'video/quicktime', 'video/webm', 'video/x-matroska', 'video/x-ms-wmv', 'video/x-flv', 'video/x-msvideo']
  #/\Avideo\/.*\Z/
  validates :video_url, :presence => true

  #scope
  scope :video_without_duration, -> {where(duration: nil)}

  def generate_mp4(video_url)
    logger.warn("=================inside generate_mp4 method===================")
    options = {resolution: "800x400",custom: %w(-vf crop=60:60:10:10 -map 0:0 -map 0:1 -strict -2)}

    if video_url.present? #&& video_url_file_name.split('.').last != "mp4"
      logger.warn("=================Not mp4 video===================")
      filename = "media1#{Time.now.to_i}"
      #if File.exists?"#{video_url.path}"
        movie = FFMPEG::Movie.new("#{video_url.url}")
        movie.transcode("#{Rails.root.to_s}/public/tmp/#{filename}.mp4",options)
        f = File.open("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        self.duration = movie.duration
        self.video_url = f
        self.save
        f.close
        movie1 = FFMPEG::Movie.new("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        File.delete("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
      #end
    else
      # if File.exists?"#{video_url.path}"
      #   movie = FFMPEG::Movie.new("#{video_url.path}")
      #   self.duration = movie.duration
      #   self.save
      # end
    end
    return
  end
  #handle_asynchronously :generate_mp4

end