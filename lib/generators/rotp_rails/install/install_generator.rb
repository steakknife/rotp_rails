module RotpRails
  autoload :Defaults, 'rotp_rails/defaults'
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc 'Installs rotp_rails and generates the necessary migrations'
      argument :name, type: :string, default: Defaults::DEFAULT_MODEL_NAME
      argument :default_secret_attribute_name, type: :string, default: Defaults::DEFAULT_SECRET_ATTRIBUTE_NAME
      argument :default_issuer, type: :string, default: Defaults::DEFAULT_ISSUER
      argument :default_label, type: :string, default: Defaults::DEFAULT_LABEL

      def self.source_root
        @_rotp_rails_source_root ||= File.expand_path('../templates', __FILE__)
      end

      def copy_initializer
        template 'rotp_rails_initializer.rb.erb', 'config/initializers/rotp_rails.rb'
      end

      def create_migrations
        @table_name = name.underscore
        file_prefix = "add_rotp_rails_to_#{@table_name}"
        @migration_classname = file_prefix.camelize
        migration_template 'migrations/add_rotp_rails_to_existing_model.rb.erb', "#{file_prefix}.rb"
      end
    end
  end
end
