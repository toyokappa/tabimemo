if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: "AWS",
      region: "ap-northeast-1",
      path_style: true
    }
    config.fog_public = false
    config.fog_attributes = { "Cache-Control": "public, max-age=86400" }
    config.remove_previously_stored_files_after_update = false
    config.fog_directory = "tabimemo-#{Rails.env}-resources"
    config.asset_host = Rails.configuration.x.asset_host
  end
end

# 日本語の文字化けを防ぐ
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
