require 'open-uri'
require 'digest'

module RuWeixin
  module Auth
    BASE_PATH = 'https://open.weixin.qq.com/connect/oauth2/authorize'.freeze
    SNS_BASE = 'https://api.weixin.qq.com/sns'.freeze
    API_BASE = 'https://api.weixin.qq.com/cgi-bin'.freeze

    class << self
      def anonymous_authorize_url(redirect_url, app_id = RuWeixin.app_id)
        "#{RuWeixin::Auth::BASE_PATH}?appid=#{app_id}&redirect_url=#{redirect_url}&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect"
      end

      def authorize_url(redirect_url, app_id = RuWeixin.app_id)
        "#{RuWeixin::Auth::BASE_PATH}?appid=#{app_id}&redirect_uri=#{redirect_url}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
      end

      def access_token_url(code)
        "#{RuWeixin::Auth::SNS_BASE}/oauth2/access_token?appid=#{RuWeixin.app_id}&secret=#{RuWeixin.secret}&code=#{code}&grant_type=authorization_code"
      end

      def user_profile_url(access_token, open_id)
        "#{RuWeixin::Auth::SNS_BASE}/userinfo?access_token=#{access_token}&openid=#{open_id}&lang=zh_CN"
      end

      def access_token
        response = open("#{RuWeixin::Auth::API_BASE}/token?grant_type=client_credential&appid=#{RuWeixin.app_id}&secret=#{RuWeixin.secret}").read
        json = JSON.parse(response)
        json['access_token']
      end

      def ticket(access_token)
        response = open("#{RuWeixin::Auth::API_BASE}/ticket/getticket?access_token=#{access_token}&type=jsapi").read
        json = JSON.parse(response)
        json['ticket']
      end

      def js_sign_package(url, ticket)
        timestamp = Time.now.to_i
        noncestr = SecureRandom.hex(16)
        str = "jsapi_ticket=#{ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"

        signature = Digest::SHA1.hexdigest(str)
        {
          appId: RuWeixin.app_id,
          nonceStr: noncestr,
          timestamp: timestamp,
          url: url,
          signature: signature,
          rawString: str
        }.with_indifferent_access
      end
    end
  end
end
