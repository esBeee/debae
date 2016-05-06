# Read more about the configuration options here
# http://www.rubydoc.info/gems/paperclip/Paperclip/Storage/S3

Paperclip::Attachment.default_options[:url] = ":s3_domain_url"

# Set the path within the bucket, the object will be uploaded to.
Paperclip::Attachment.default_options[:path] = "/:class/:attachment/:id_partition/:style/:filename"

# Set the bucket region.
Paperclip::Attachment.default_options[:s3_region] = "eu-central-1"

# Create HTTPS links.
Paperclip::Attachment.default_options[:s3_protocol] = "https"
