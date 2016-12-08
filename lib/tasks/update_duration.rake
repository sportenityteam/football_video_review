namespace :football_review do
  desc "Update Duration"
	task update_video_duration: :environment do
		if Rails.env == "production"
			`bin/delayed_job start RAILS_ENV=production`
		else
			`bin/delayed_job start`
		end
		@video = Video.video_without_duration
		@video.each do |video|
			video.generate_mp4(video.video_url)
			movie = FFMPEG::Movie.new("#{video.video_url.url}")
			if movie.present?
				video.duration = movie.duration
				video.order.total_video_duration = 0 if video.order.total_video_duration.nil?
				video.order.total_video_duration += movie.duration.to_i
    		video.order.save
				video.save
			end
		end
	end
end