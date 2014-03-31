require 'active_support/concern'
require 'rotp'
require 'rqrcode'

module RotpRails
  autoload :Defaults, 'rotp_rails/defaults'

  module Concern
    extend ActiveSupport::Concern

    module ClassMethods
      attr_writer :rotp_issuer, :rotp_label, :rotp_secret_attribute_name

      def rotp_secret_attribute_name
        @rotp_secret_attribute_name ||= ::RotpRails.config.default_secret_attribute_name
      end

      def rotp_issuer
        @rotp_issuer ||= ::RotpRails.config.default_issuer
      end

      def rotp_label
        @rotp_label ||= ::RotpRails.config.default_label
      end

      def rotp_generate_secret
        ::ROTP::Base32.random_base32
      end

    private
      def rotp(options={})
        [:secret_attribute_name, :issuer, :label].map { |x|
          instance_variable_set("@rotp_#{x}".to_sym, options[x]) if options[x]
        }
      end
    end

    def rotp_valid?(code)
      ::ROTP::TOTP.new(rotp_secret_value).verify_with_drift(code, Defaults::VALIDATE_CODE_WITHIN) if rotp_secret_value
    end

    def rotp_qrcode_url
      ::ROTP::TOTP.new(rotp_secret, issuer: rotp_issuer).provisioning_uri(rotp_label_formatted)
    end

    attr_writer :rotp_issuer, :rotp_label, :rotp_secret_attribute_name

    def rotp_issuer
      @rotp_issuer ||= self.class.rotp_issuer
    end

    def rotp_label_formatted
      x = rotp_label
      x.gsub!('%e', self.email) if x =~ /%e/
      x.gsub!('%n', self.name) if x =~ /%n/
      x.gsub!('%%', '%')
      x
    end

    def rotp_label
      @rotp_label ||= self.class.rotp_label
    end

    def rotp_secret_attribute_name
      @rotp_secret_attribute_name ||= self.class.rotp_secret_attribute_name
    end

    def rotp_qrcode
      ::RQRCode::QRCode.new(rotp_qrcode_url, size: Defaults::QRCODE_SIZE, level: Defaults::QRCODE_LEVEL)
    end

    def rotp_enroll
      rotp_set_secret
      save
    end

    def rotp_enroll!
      raise 'Already enrolled' if rotp_enrolled?
      rotp_set_secret
      save!
    end

    def rotp_enrolled?
      !rotp_secret_value.blank? && persisted?
    end

    def rotp_unenroll
      update_attributes(rotp_secret_attribute_name.to_sym => nil)
    end

    def rotp_unenroll!
      update_attributes!(rotp_secret_attribute_name.to_sym => nil)
    end

    def rotp_secret_value
      send(rotp_secret_attribute_name.to_sym)
    end

    def rotp_secret_pretty
      rotp_secret_value.scan(/..../).join(' ')
    end

  protected

    def rotp_secret_value=(x)
      send("#{self.rotp_secret_attribute_name}=".to_sym, x)
    end

    def rotp_set_secret
      self.rotp_secret_value ||= self.class.rotp_generate_secret
    end
  end
end

