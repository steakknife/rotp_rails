module RotpRails
  module Defaults
    QRCODE_SIZE = 8
    QRCODE_LEVEL = :h

    VALIDATE_CODE_WITHIN = 6.seconds

    DEFAULT_MODEL_NAME = 'User'
    DEFAULT_SECRET_ATTRIBUTE_NAME = :rotp_secret
    DEFAULT_ISSUER = 'RotpRails'
    DEFAULT_LABEL = '%e'
  end
end

