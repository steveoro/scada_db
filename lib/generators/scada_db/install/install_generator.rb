require 'rails/generators/base'


module ScadaDb
  module Generators


=begin

= InstallGenerator

  - version:  0.0.3
  - author:   Steve A.

This install generator will:

  1. prepare the base folder structure for the DB management; typically:
        db/diff.applied
        db/diff.new
        db/dump
        db/seed

  2. copy the latest available (committed) DB structure dump
     into the dedicated folder:
        db/dump/development.sql.bz2

  3. copy any available factory into the mounting app
     spec/factories folder

  4. copy any available spec/support file into the mounting app
     spec/support folder


The db/dump folder contains the structure dumps that can be recreated
easily with:

  > zeus rake db:rebuild_from_dump # (when using Zeus)
  ...Or...
  > bundle exec rake db:rebuild_from_dump

The additional db/diff.new and db/diff.applied folders can be used
to store SQL diff files to be applied to the dump using the dedicated
rake task db:diff_apply

Check out the corresponding rake task descriptions for more info.


=== Usage:

  > rails g scada_db:install

=end
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_db_files
        source_dir = File.expand_path("../templates", __FILE__)
        directory source_dir, "db"
      end

      def copy_factories
        source_dir = File.expand_path("../../../../../spec/factories", __FILE__)
        directory source_dir, "spec/factories"
      end

      def copy_support
        source_dir = File.expand_path("../../../../../spec/support", __FILE__)
        directory source_dir, "spec/support"
      end
      #-- ---------------------------------------------------------------------
      #++
    end
  end
end
