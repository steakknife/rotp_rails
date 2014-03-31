require 'rotp_rails/config/dsl'

module RotpRails
  module Config
    def config
      @config ||= Config::DSL.new
      block_given? ? yield(@config) : @config
    end
  end
end
