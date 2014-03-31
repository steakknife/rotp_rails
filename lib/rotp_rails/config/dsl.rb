
module RotpRails
  autoload :Defaults, 'rotp_rails/defaults'
  module Config
    class DSL
      attr_accessor :default_secret_attribute_name
      attr_accessor :default_label
      attr_accessor :default_issuer

      def initialize
        @default_secret_attribute_name = Defaults::DEFAULT_SECRET_ATTRIBUTE_NAME
        @default_issuer = Defaults::DEFAULT_ISSUER
        @default_label = Defaults::DEFAULT_LABEL
      end
    end
  end
end
