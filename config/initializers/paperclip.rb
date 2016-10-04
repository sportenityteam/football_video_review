Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'
Paperclip::Attachment.default_options[:region] = 'us-west-2'
Paperclip.options[:content_type_mappings] = {nil => "video/mp4"}