require 'rqrcode'

class HomeController < ApplicationController
  def index
    @qr = RQRCode::QRCode.new('https://www.duckduckgo.com', size: 4, level: :h)
  end
end
