require 'rails/generators/base'


module ScadaDb
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_db_files
        source_dir = File.expand_path("../templates", __FILE__)
        directory source_dir, "db"
      end
      #-- ---------------------------------------------------------------------
      #++
    end
  end
end
