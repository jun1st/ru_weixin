require 'open-uri'

module RuWeixin
  module Account
    BASE_PATH = 'https://api.weixin.qq.com/cgi-bin'.freeze

    class << self
      def access_token(app_name = nil)
        app_id = RuWeixin.app_id
        secret = RuWeixin.secret
        if app_name && RuWeixin.stores
          app = RuWeixin.stores[app_name]
          if app
            app_id = app[:app_id]
            secret = app[:secret]
          end
        end
        response = open("#{RuWeixin::Account::BASE_PATH}/token?grant_type=client_credential&appid=#{app_id}&secret=#{secret}").read
        json = JSON.parse(response)
        json['access_token']
      end

      def get_user(open_id, access_token)
        url = "#{RuWeixin::Account::BASE_PATH}/user/info?access_token=#{access_token}&openid=#{open_id}&lang=zh_CN"
        response = open(url).read
        JSON.parse(response)
      end
    end
  end
end
