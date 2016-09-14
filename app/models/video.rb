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

end
