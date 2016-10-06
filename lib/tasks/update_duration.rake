namespace :football_review do
  desc "Update Duration"
	task update_video_duration: :environment do
		@video = Video.video_without_duration
		@video.each do |video|
			movie = FFMPEG::Movie.new("#{video.video_url.url}")
			if movie.present?
				video.duration = movie.duration
				video.order.total_video_duration += movie.duration
    			video.order.save
				video.save
			end
		end
	end
end