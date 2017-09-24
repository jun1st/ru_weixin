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

        response = open("#{RuWeixin::Auth::API_BASE}/token?grant_type=client_credential&appid=#{app_id}&secret=#{secret}").read
        json = JSON.parse(response)
        json['access_token']
      end
    end
  end
end
