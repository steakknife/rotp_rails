class User < ActiveRecord::Base
  include ::RotpRails::Concern

  rotp issuer: 'Foo', label: 'Your Email'

  validates :name, presence: true, uniqueness: true

  attr_accessor :rotp_code

  validates :rotp_code, format: { with: /\A[0-9]{6}\z/, allow_nil: true }
end
