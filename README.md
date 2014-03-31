# RotpRails


### Manual default setup

1. Add `gem 'rotp_rails'` to the Gemfile

1. `bundle`

1. In the controller, add the following field to the User or whatever model migration

    bundle exec rails g migration AddRotpSecretToUser rotp_secret:string

1.  Migrate db

    bundle exec rake db:migrate

1. Add this to the top of the User or whatever model

    class User < ActiveRecord::Base
      include RotpRails::Concern
      
      # ...
    end

1. To enroll the user

    # In your controller
    if @user.rotp_enroll! rescue nil
      # just enrolled
    else
      # already enrolled
    end

    # In your views
    <%= render partial: 'qrcode', object: @user.rotp_qrcode %>
    <%= @user.rotp_secret_pretty %>
   
1. To determine if the code is valid

    @user.rotp_valid? '123456'

### Global configuration

    # config/initializer/rotp_rails.rb
    RotpRails.config do |config|
      config.default_secret_attribute_name = :google_mfa_secret_token
      config.default_issuer = 'Widgets App'
      config.default_label = 'Joe Bob'
    end

### Per model configuration

    class User < ActiveRecord::Base
      include RotpRails::Concern

      rotp secret_attribute_name: 'google_secret',
           issuer: 'Your Awesome Indycorp',
           label: '%e' # %e = email, %n = name, %% = %

      # ...

    end


### To change the field name in one object (yes, that granular)

     # configure somewhere
     @user.rotp_secret_attribute_name = :your_alternate_column
     @user.rotp_issuer = 'Whatever'
     @user.rotp_label = 'Joe Bob'

     # in views
     @user.rotp_qrcode
     @user.rotp_secret_value # or @user.rotp_secret_pretty # with spaces
