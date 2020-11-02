require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def get_image_data(image_file)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      Rails.logger.debug ENV['GOOGLE_API_KEY']

      # 画像をbase64にエンコード
      Rails.logger.debug "ここ1？"
      base64_image = Base64.encode64(open("#{Rails.root}/public#{image_file}").read)

      # APIリクエスト用のJSONパラメータ
      Rails.logger.debug "ここ2？"
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'SAFE_SEARCH_DETECTION'
            }
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      Rails.logger.debug "ここ3？"
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      Rails.logger.debug response

      # APIレスポンス出力
      Rails.logger.debug "ここ4？"
      Rails.logger.debug "#{Rails.root}/public#{image_file}"
      Rails.logger.debug "ここ5？"
      Rails.logger.debug JSON.parse(response.body)
      result = JSON.parse(response.body)['responses'][0]['safeSearchAnnotation']
      if result.value?("LIKELY") || result.value?("VERY_LIKELY")
        return false
      else
        return true
      end
    end
  end
end