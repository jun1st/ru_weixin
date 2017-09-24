require "ru_weixin/version"
require 'ru_weixin/auth'
require 'ru_weixin/account'

module RuWeixin
  class << self
    attr_accessor :app_id, :secret, :stores
  end
end
