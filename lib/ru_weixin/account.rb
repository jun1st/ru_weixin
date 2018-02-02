require 'open-uri'
require 'base64'
require 'openssl'

module RuWeixin
  module Account
    BASE_PATH = 'https://api.weixin.qq.com/cgi-bin'.freeze
    USER_PATH = 'https://api.weixin.qq.com/sns'

    class << self
      def get_access_token(app_name = nil)
        app_id = RuWeixin.app_id
        secret = RuWeixin.secret
        if app_name && RuWeixin.stores
          app = RuWeixin.stores[app_name]
          if app
            app_id = app[:app_id]
            secret = app[:secret]
          end
        end

        RuWeixin.cache.fetch "#{app_id}_access_token", expires_in: 7100 do
          response = open("#{RuWeixin::Account::BASE_PATH}/token?grant_type=client_credential&appid=#{app_id}&secret=#{secret}").read
          json = JSON.parse(response)
          json['access_token']
        end
      end

      def get_user(open_id, app_name = nil)
        access_token = get_access_token(app_name)
        url = "#{RuWeixin::Account::BASE_PATH}/user/info?access_token=#{access_token}&openid=#{open_id}&lang=zh_CN"
        response = open(url).read
        JSON.parse(response)
      end

      def get_session_key(app_id, secret, code)
        url = "#{RuWeixin::Account::USER_PATH}/jscode2session?appid=#{app_id}&secret=#{secret}&js_code=#{code}&grant_type=authorization_code"
        response = open(url).read
        JSON.parse(response)
      end

      def decrypt_data(session_key, iv, encrypted_data)
        aesKey = Base64.decode(session_key)
        d_iv = Base64.decode(iv)
        data = Base64.decode(encrypted_data)
        cipher = OpenSSL::Cipher::AES.new(128, :CBC)
        cipher.decrypt
        cipher.key = aesKey
        cipher.iv = d_iv
        cipher.update(data) + cipher.final
      end
    end
  end
end
