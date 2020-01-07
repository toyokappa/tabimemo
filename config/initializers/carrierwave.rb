CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      use_iam_profile: true,
      region: "ap-northeast-1",
      path_style: true
    }
    config.fog_public = false
    config.fog_attributes = { "Cache-Control": "public, max-age=86400" }
    config.remove_previously_stored_files_after_update = false
    config.fog_directory = "tabimemo-#{Rails.env}-uploads"
    config.asset_host = Rails.configuration.x.asset_host
  else
    config.storage = :file
  end
end

# 日本語の文字化けを防ぐ
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
