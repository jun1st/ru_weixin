require "ru_weixin/version"
require 'ru_weixin/auth'

module RuWeixin
  class << self
    attr_accessor :app_id, :secret
  end
end
