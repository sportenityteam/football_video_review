namespace :football_review do
  desc "Update Duration"
	task update_video_duration: :environment do
		@video = Video.video_without_duration
		@video.each do |video|
			movie = FFMPEG::Movie.new("#{video.video_url.path}")
			if movie.present?
				video.duration = movie.duration
				video.save
			end
		end
	end
end