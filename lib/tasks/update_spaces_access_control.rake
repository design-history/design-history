require "aws-sdk-s3"

namespace :spaces do
  desc "Update access control settings for all objects in the DigitalOcean Spaces bucket"
  task update_access_control: :environment do
    # Replace with your own credentials and bucket information
    access_key_id =
      Rails.application.credentials.dig(:digitalocean, :access_key)
    secret_access_key =
      Rails.application.credentials.dig(:digitalocean, :secret)
    region = "ams3"
    bucket_name = "design-history"

    # Initialize the S3 client
    s3_client =
      Aws::S3::Client.new(
        access_key_id:,
        secret_access_key:,
        region:,
        endpoint: "https://#{region}.digitaloceanspaces.com"
      )

    # Update the access control settings for each object in the bucket
    s3_resource = Aws::S3::Resource.new(client: s3_client)
    bucket = s3_resource.bucket(bucket_name)

    bucket.objects.each do |object|
      puts "Updating access control for #{object.key}"
      object.acl.put({ acl: "public-read" })
    end
  end
end
