require 'rails'

require 'rotp_rails/concern'
require 'rotp_rails/config'

module RotpRails
  extend Config

  module Rails
    class Engine < ::Rails::Engine
    end
  end
end
