require 'rails/generators/base'


module ScadaDb
  module Generators


=begin

= InstallGenerator

  - version:  0.0.3
  - author:   Steve A.

Commodity generator that allows to have a base DB structure copied
directly under the /db folder.

The db/dump folder contains the structure dumps that can be recreated
easily with:

  > zeus rake db:rebuild_from_dump # (when using Zeus)

  ...Or...

  > bundle exec rake db:rebuild_from_dump

The additional db/diff.new and db/diff.applied folders can be used
to store SQL diff files to be applied to the dump using the dedicated
rake task db:diff_apply


=== Usage:

  > rails g scada_db:install

=end
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
