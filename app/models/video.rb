class Video < ActiveRecord::Base
  #associations
  belongs_to :order

  #paperclip
  has_attached_file :video_url,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename",
                    :styles => {
                                :medium => { :geometry => "800x400<", :format => 'mp4' },
                                :thumb1 => { :geometry => "120x120#", :format => 'jpg', :time => 1 },
                                :thumb => { :geometry => "512x512#", :format => 'jpg', :time => 1 }
                               }, :processors => [:transcoder]


  #validations
  validates_attachment_content_type :video_url, :content_type => /\Avideo\/.*\Z/
  validates :video_url, :presence => true

  def generate_mp4(video_url)
    if self.video_url.present? && self.video_url_file_name.split('.').last != "mp4"
      filename = "media1#{Time.now.to_i}"
      if File.exists?"#{video_url.path}"
        movie = FFMPEG::Movie.new("#{video_url.path}")
        movie.transcode("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        f = File.open("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        self.duration = movie.duration
        self.video_url = f
        self.save
        f.close
        movie1 = FFMPEG::Movie.new("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
        File.delete("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
      end
    else
      if File.exists?"#{video_url.path}"
        movie = FFMPEG::Movie.new("#{video_url.path}")
        self.duration = movie.duration
        self.save
      end
    end
  end
  handle_asynchronously :generate_mp4

end