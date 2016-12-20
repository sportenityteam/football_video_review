namespace :football_review do
  desc "Update Duration"
	task update_video_duration: :environment do
		@videos = Video.video_without_duration
		if @videos.present?
			@videos.each do |video|
				#video.generate_mp4(video.video_url)
				puts("=================inside video loop method===================")
    		#options = {resolution: "800x400",custom: %w(-vf crop=60:60:10:10 -map 0:0 -map 0:1 -strict -2)}
    		#options = {custom: %w(-s 800x400 -c:a copy)}
    		if video.video_url.present?
					movie = FFMPEG::Movie.new("#{video.video_url.url}")

					if movie.present?
						puts("=================inside movie ===================")

						video.duration = movie.duration
						video.order.total_video_duration = 0 if video.order.total_video_duration.nil?
						video.order.total_video_duration += movie.duration.to_i
		    		video.order.save
						video.save
						if !(video.video_url_content_type == "video/mp4")
							puts("==============-=---=video==========#{video.inspect}=========")
							video_url = video.video_url
			      	filename = "media1#{Time.now.to_i}"
			        #movie.transcode("#{Rails.root.to_s}/public/tmp/#{filename}.mp4",options)
			        #`ffmpeg -i "#{video.video_url.url}" -c:a copy "#{Rails.root.to_s}/public/tmp/#{filename}.mp4"`
			        if video.video_url_content_type == "video/x-flv"
			        	`ffmpeg -i "#{video.video_url.url}" "#{Rails.root.to_s}/public/tmp/#{filename}.mp4"`
			        elsif video.video_url_content_type == "video/x-msvideo"
			        # 	`ffmpeg -i "#{video.video_url.url}" -ar 22050 -ab 32 "#{Rails.root.to_s}/public/tmp/#{filename}.mp4"`
			        	`ffmpeg -i "#{video.video_url.url}" -c:v libx264 -crf 19 -preset slow -c:a aac -strict experimental -b:a 192k -ac 2 "#{Rails.root.to_s}/public/tmp/#{filename}.mp4"`
			        else
			        	`ffmpeg -i "#{video.video_url.url}" -c:v copy -c:a copy "#{Rails.root.to_s}/public/tmp/#{filename}.mp4"`
			        end
			        f = File.open("#{Rails.root.to_s}/public/tmp/#{filename}.mp4")
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
	end
end