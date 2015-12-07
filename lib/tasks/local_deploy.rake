# encoding: utf-8

require 'date'
require 'rubygems'
require 'find'
require 'fileutils'

require 'common/format'
require 'scada_db/version'


=begin

= Local Deployment helper tasks

  - Tasks inherited from AgeX framework, (p) FASAR Software 2007-2015
  - SCADA_SUP framework vers.:  1.00.00
  - author: Steve A.

  ** These tasks must be accessible from the Rails.root **

=end

# Script revision number
SCRIPT_VERSION = '5.00.001'

# Gives current application name
APP_NAME = Dir.pwd.to_s.split( File::SEPARATOR ).reverse[0]
APP_VERSION = ScadaDb::VERSION

MAX_BACKUP_KEPT = 30
DB_BACKUP_DIR  = File.join( "#{Dir.pwd}.docs", 'backup.db' )
TAR_BACKUP_DIR = File.join( "#{Dir.pwd}.docs", 'backup.src' )
LOG_BACKUP_DIR = File.join( "#{Dir.pwd}.docs", 'backup.log' )

DB_SEED_DIR    = File.join( Dir.pwd, 'db/seed' ) unless defined? DB_SEED_DIR
UPLOADS_DIR    = File.join( Dir.pwd, 'public/uploads' ) unless defined? UPLOADS_DIR
# The following is used only for clearing temp file
ODT_OUTPUT_DIR = File.join( Dir.pwd, 'public/output' ) unless defined? ODT_OUTPUT_DIR

NEEDED_DIRS = [
  DB_BACKUP_DIR, DB_SEED_DIR, UPLOADS_DIR,
  TAR_BACKUP_DIR, LOG_BACKUP_DIR
]

puts "\r\nAdditional local-build/deploy helper tasks loaded."
puts "- Script version  : #{SCRIPT_VERSION}"



# Returns the full path of a directory with respect to current Application root dir, terminated
# with a trailing slash.
# Current working directory will also be set to Dir.pwd (application root dir) anyways.
#
def get_full_path( sub_path )
  File.join( Dir.pwd, sub_path )
end
#-- ---------------------------------------------------------------------------
#++


# Rotate backups inside a specific 'backup_folder' allowing only a maximum number of 'max_backups'
# (for each backup type) and deleting in rotation the oldest ones.
#
def rotate_backups( backup_folder, max_backups )
    all_backups = Dir.glob(File.join(backup_folder, '*'), File::FNM_PATHNAME).sort.reverse
    unwanted_backups = all_backups[max_backups..-1] || []
                                                    # Remove the backups in excess:
    for unwanted_backup in unwanted_backups
      puts "Deleting older backup #{unwanted_backup} ..."
      FileUtils.rm( unwanted_backup )
    end
    puts "Removed #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available."
end
#-- ===========================================================================
#++


# [Steve, 20130808] The following will remove the task db:test:prepare
# to avoid having to wait each time a test is run for the db test to reset
# itself:
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
#Rake.application.remove_task 'db:reset'
#Rake.application.remove_task 'db:test:prepare'


namespace :db do
#  namespace :test do
#    task :prepare do |t|
      # rewrite the task to not do anything you don't want
#    end
#  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  This is an override of the standard Rake db:reset task.
It actually DROPS the Database, recreates it using a mysql shell command.

Options: [Rails.env=#{Rails.env}]

  DESC
  task :hard_reset do |t|
    puts "*** Task: Custom DB RESET ***"
    rails_config  = Rails.configuration             # Prepare & check configuration:
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']
                                                    # Display some info:
    puts "DB name:      #{db_name}"
    puts "DB user:      #{db_user}"
    puts "\r\nDropping DB..."
    sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --execute=\"drop database if exists #{db_name}\""
    puts "\r\nRecreating DB..."
    sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --execute=\"create database #{db_name}\""
  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  Recreates the current DB from scratch.
Invokes the following tasks in in one shot:

  - db:reset           ...to clear the current DB (default: development);
  - db:migrate         ...to run migrations;
  - sql:exec           ...to import the base seed files (/db/seed/*.sql);
  - db:update_records  ...to pre-compute & fill the individual_records table;

Keep in mind that, when not in production, the test DB must then be updated
using the db:clone_to_test dedicated task.

Options: [Rails.env=#{Rails.env}]

  DESC
  task :rebuild_from_scratch do
    puts "*** Task: Compound DB RESET + MIGRATE + SQL:EXEC + DB:SEED ***"
    Rake::Task['app:db:hard_reset'].invoke
    Rake::Task['app:db:migrate'].invoke
    Rake::Task['app:sql:exec'].invoke
    Rake::Task['app:db:seed'].invoke
    puts "Done."
  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  Similarly to sql:dump, db:dump creates a bzipped MySQL dump of the whole DB for
later restore.
The resulting file does not contain any "create database" statement and it can be
executed freely on any empty database with any name of choice.

The file is stored as:

  - 'db/dump/#{Rails.env}.sql.bz2'

This is assumed to be kept under the source tree repository and used for a quick recovery
of the any of the DB structures using the dedicated task "db:rebuild_from_dump".

Options: [Rails.env=#{Rails.env}]

  DESC
  task :dump => [ 'app:utils:script_status' ] do
    puts "*** Task: DB dump for quick recovery ***"
                                                    # Prepare & check configuration:
    rails_config  = Rails.configuration
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']
    db_dump( db_host, db_user, db_pwd, db_name, Rails.env )
  end


  # Performs the actual operations required for a DB dump update given the specified
  # parameters.
  #
  # Note that the dump takes the name of the Environment configuration section.
  #
  def db_dump( db_host, db_user, db_pwd, db_name, dump_basename )
    puts "\r\nUpdating recovery dump '#{ dump_basename }' (from #{db_name} DB)..."
    zip_pipe = ' | bzip2 -c'
    file_ext = '.sql.bz2'                           # Display some info:
    puts "DB name: #{ db_name }"
    puts "DB user: #{ db_user }"
    file_name = File.join( File.join('db', 'dump'), "#{ dump_basename }#{ file_ext }" )
    puts "\r\nProcessing #{ db_name } => #{ file_name } ...\r\n"
    # To disable extended inserts, add this option: --skip-extended-insert
    # (The Resulting SQL file will be much longer, though -- but the bzipped
    #  version can result more compressed due to the replicated strings, and it is
    #  indeed much more readable and editable...)
    sh "mysqldump --host=#{ db_host } -u #{ db_user } --password=\"#{db_pwd}\" -l --triggers --routines -i --skip-extended-insert --no-autocommit --single-transaction #{ db_name } #{ zip_pipe } > #{ file_name }"
    puts "\r\nRecovery dump created.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  Recreates the current DB from a recovery dump created with db:dump.

Options: [Rails.env=#{Rails.env}]
         [from=dump_base_name|<#{Rails.env}>]
         [to='production'|'development'|'test']

  - from: when not specified, the source dump base name will be the same of the
        current Rails.env

  - to: when not specified, the destination database will be the same of the
        current Rails.env

  DESC
  task :rebuild_from_dump => [ 'app:utils:script_status' ] do
    puts "*** Task: DB rebuild from dump ***"
                                                    # Prepare & check configuration:
    rails_config  = Rails.configuration
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']
    dump_basename = ENV.include?("from") ? ENV["from"] : Rails.env
    output_db     = ENV.include?("to")   ? rails_config.database_configuration[ENV["to"]]['database'] : db_name
    file_ext      = '.sql.bz2'

    rebuild_from_dump( dump_basename, output_db, db_host, db_user, db_pwd, file_ext )
  end


  # Performs the actual sequence of operations required by a single db:rebuild_from_dump
  # task, given the specified parameters.
  #
  # The source_basename comes from the name of the file dump.
  # Note that the dump takes the name of the Environment configuration section.
  #
  def rebuild_from_dump( source_basename, output_db, db_host, db_user, db_pwd, file_ext = '.sql.bz2' )
    puts "\r\nRebuilding..."
    puts "DB name: #{ source_basename } (dump) => #{ output_db } (DEST)"
    puts "DB user: #{ db_user }"

    file_name = File.join( File.join('db', 'dump'), "#{ source_basename }#{ file_ext }" )
    sql_file_name = File.join( 'tmp', "#{ source_basename }.sql" )

    puts "\r\nUncompressing dump file '#{ file_name }' => '#{ sql_file_name }'..."
    sh "bunzip2 -ck #{ file_name } > #{ sql_file_name }"

    puts "\r\nDropping destination DB '#{ output_db }'..."
    sh "mysql --host=#{ db_host } --user=#{ db_user } --password=\"#{db_pwd}\" --execute=\"drop database if exists #{ output_db }\""
    puts "\r\nRecreating destination DB..."
    sh "mysql --host=#{ db_host } --user=#{ db_user } --password=\"#{db_pwd}\" --execute=\"create database #{ output_db }\""

    puts "\r\nExecuting '#{ file_name }' on #{ output_db }..."
    sh "mysql --host=#{ db_host } --user=#{ db_user } --password=\"#{db_pwd}\" --database=#{ output_db } --execute=\"\\. #{ sql_file_name }\""
    puts "Deleting uncompressed file '#{ sql_file_name }'..."
    FileUtils.rm( sql_file_name )

    puts "Rebuild from dump for '#{ source_basename }', done.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  Clones the development or production database to the test database (according to
Rails environment; default is obviously 'development').

Assumes development db name ends in '_development' and production db name doesn't
have any suffix.

Options: [Rails.env=#{Rails.env}]

  DESC
  task :clone_to_test => ['app:utils:script_status', 'app:utils:chk_needed_dirs'] do
    puts "*** Task: Clone DB on TEST DB ***"
    if (Rails.env == 'test')
      puts "You must specify either 'development' or 'production'!"
      exit
    end
                                                    # Prepare & check configuration:
    rails_config  = Rails.configuration
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']
    output_folder = ENV.include?("output_dir") ? ENV["output_dir"] : DB_BACKUP_DIR
                                                    # Display some info:
    puts "DB name: #{db_name}"
    puts "DB user: #{db_user}"
    file_name = File.join( output_folder, "#{db_name}-clone.sql" )
    puts "\r\nDumping #{db_name} on #{file_name} ...\r\n"
    sh "mysqldump --host=#{db_host} -u #{db_user} --password=\"#{db_pwd}\" --triggers --routines -i -e --no-autocommit --single-transaction #{db_name} > #{file_name}"
    base_db_name = db_name.split('_development')[0]
    puts "\r\nDropping Test DB '#{base_db_name}_test'..."
    sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --execute=\"drop database if exists #{base_db_name}_test\""
    puts "\r\nRecreating DB..."
    sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --execute=\"create database #{base_db_name}_test\""
    puts "\r\nExecuting '#{file_name}' on #{base_db_name}_test..."
    sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --database=#{base_db_name}_test --execute=\"\\. #{file_name}\""
    puts "Deleting dump file '#{file_name}'..."
    FileUtils.rm( file_name )

    puts "Clone on Test DB done.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++

end
# =============================================================================



namespace :sql do

  desc <<-DESC
  Creates a bzipped MySQL dump of the whole DB or just of a few tables, rotating the backups.

Options: [db_version=<db_struct_version>] [bzip2=<1>|0]
         [output_dir=#{DB_BACKUP_DIR}] [max_backup_kept=#{MAX_BACKUP_KEPT}] [Rails.env=#{Rails.env}]
  DESC
  task :dump => ['app:utils:script_status', 'app:utils:chk_needed_dirs'] do
    puts "*** Task: SQL DB dump ***"
                                                    # Prepare & check configuration:
    rails_config  = Rails.configuration
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']

# TODO [FUTUREDEV] get current version from app_parameter table
    db_version    = ENV.include?("db_version") ? ENV['db_version'] + '.' + DateTime.now.strftime("%Y%m%d.%H%M") : 'backup' + '.' + DateTime.now.strftime("%Y%m%d.%H%M%S")
    max_backups   = ENV.include?("max_backup_kept") ? ENV["max_backup_kept"].to_i : MAX_BACKUP_KEPT
    backup_folder = ENV.include?("output_dir") ? ENV["output_dir"] : DB_BACKUP_DIR
                                                    # Compress output? (Default = yes)
    unless ( ENV.include?("bzip2") && (ENV["bzip2"].to_i < 1) )
      zip_pipe = ' | bzip2 -c'
      file_ext = '.sql.bz2'
    else
      zip_pipe = ''
      file_ext = '.sql'
    end
                                                    # Display some info:
    puts "DB name:          #{db_name}"
    puts "version code:     #{db_version}"
    puts "DB user:          #{db_user}"
    puts "extracted tables: " + ( ENV.include?("tables") ? tables : "(entire DB)" )
    file_name = File.join( backup_folder, ( ENV.include?("tables") ? "#{db_name}-update-tables#{file_ext}" : "#{db_name}-#{db_version}#{file_ext}" ) )
    puts "Creating #{file_name} ...\r\n"
    sh "mysqldump --host=#{db_host} -u #{db_user} --password=\"#{db_pwd}\" --add-drop-database --add-drop-table --extended-insert --triggers --routines --comments -c -i --no-autocommit --single-transaction -B #{db_name} #{zip_pipe} > #{file_name}"

                                                    # Rotate the backups leaving only the newest ones:
    rotate_backups( backup_folder, max_backups )
    puts "Dump done.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++


  desc <<-DESC
  Executes all the SQL scripts ('*.sql') found in a special directory (usually for data seed).
Allows also to clear the executed files afterwards.

Options: [exec_dir=#{DB_SEED_DIR}] [delete=1|<0>]

- 'exec_dir' is the path where the files are found
- 'delete' allows to kill the executed file after completion; defaults to '0' (false)

  DESC
  task :exec => ['app:utils:script_status', 'app:utils:chk_needed_dirs'] do
    puts "*** Task: SQL script execute ***"
                                                    # Prepare & check configuration:
    rails_config  = Rails.configuration
    db_name       = rails_config.database_configuration[Rails.env]['database']
    db_user       = rails_config.database_configuration[Rails.env]['username']
    db_pwd        = rails_config.database_configuration[Rails.env]['password']
    db_host       = rails_config.database_configuration[Rails.env]['host']
    exec_folder = ENV.include?("exec_dir") ? ENV["exec_dir"] : DB_SEED_DIR
                                                    # Display some info:
    puts "DB name:      #{db_name}"
    puts "DB user:      #{db_user}"

    if File.directory?( exec_folder )               # If directory exists, scan it and execute each SQL file found:
      puts "\r\n- Processing directory: '#{exec_folder}'..."
                                                    # For each file match in pathname recursively do "process file":
      Dir.glob( File.join(exec_folder, '*.sql'), File::FNM_PATHNAME ).sort.each do |subpathname|
        puts "executing '#{subpathname}'..."
        sh "mysql --host=#{db_host} --user=#{db_user} --password=\"#{db_pwd}\" --database=#{db_name} --execute=\"\\. #{subpathname}\""
        # TODO Eventually, capture output to a log file somewhere
                                                    # Kill the file if asked to do so:
        if ( ENV.include?("delete") && ENV.include?("delete") == '1' )
          puts "deleting '#{subpathname}'."
          FileUtils.rm( subpathname )
        end
      end
    else
      puts "Can't find directory '#{exec_folder}'! Nothing to do..."
    end

    puts "SQL script execute done.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++
end
# =============================================================================
# =============================================================================



namespace :build do

  task :default => [:help]
  #-- -------------------------------------------------------------------------
  #++

  desc 'Generic usage for the build tasks defined.'
  task :help => ['app:utils:script_status'] do
    Rake::Task['stats'].invoke
    puts "Subtasks defined for :build namespace:"
    puts "\t:maintenance\ttoggles maintenance mode for the app"
    puts "\t:log_rotate\tlog backup and rotation (uses output_dir)"
    puts "\t:tar\t\tapp tree tar backup (uses output_dir)"
    puts "\t:version\tinternal DB version update"
    puts "\t:news_log\tinternal DB blog entry update"
    puts "\t:local\t\tlocal build creation (uses output_dir)"
    puts ""
  end
  #-- -------------------------------------------------------------------------
  #++


desc <<-DESC
Sets or resets maintenance mode for the whole app by setting a proper DB flag.

If the end_date is not parsable or not provided, the default is the current time
plus 2 hours.

    Options: [mode=<1>|0] [end_date=<restore_date_in_parsable_format>]
             [Rails.env=#{Rails.env}]
DESC
  task :maintenance => [:environment, 'app:utils:script_status'] do
    end_date   = ENV.include?("end_date") ? ENV['end_date'] : nil
    versioning = AppParameter.find_by_code( AppParameter::PARAM_VERSIONING_CODE )

    if ( ENV.include?("mode") && ENV['mode'].to_i < 1 )
      puts "Toggling OFF maintenance mode..."
      versioning.a_bool = false
      versioning.a_date = nil
    else
      puts "Toggling ON maintenance mode (until '#{end_date}')..."
      versioning.a_bool = true
      begin
        versioning.a_date = DateTime.parse( end_date )
      rescue
        versioning.a_date = DateTime.now + 4.hours
      end
    end
    puts "Setting flag: #{ versioning.a_bool }, ending date: #{ Format.a_short_datetime( versioning.a_date ) }..."
    versioning.save!
    puts "Maintenance mode toggle: end."
  end
  #-- -------------------------------------------------------------------------
  #++


desc <<-DESC
Creates a new (bzipped) backup of each log file, truncating then the current ones
and clearing also the temp output dir.

    Options: [output_dir=#{LOG_BACKUP_DIR}] [max_backup_kept=#{MAX_BACKUP_KEPT}]
DESC
  task :log_rotate => ['app:utils:script_status', 'app:utils:chk_needed_dirs'] do
    puts "Saving backups of the current log files..."
                                                    # Prepare & check configuration:
    time_signature  = DateTime.now.strftime("%Y%m%d.%H%M%S")
    max_backups     = ENV.include?("max_backup_kept") ? ENV["max_backup_kept"].to_i : MAX_BACKUP_KEPT
    backup_folder   = ENV.include?("output_dir") ? ENV["output_dir"] : LOG_BACKUP_DIR
                                                    # Create a backup of each log:
    Dir.chdir( get_full_path('log') ) do |curr_path|
      for log_filename in Dir.glob(File.join("#{curr_path}",'*.log'), File::FNM_PATHNAME)
        puts "Processing #{log_filename}..."
        Dir.chdir( backup_folder )
        # Make first a copy on /tmp, so that we may archive it even if it's currently
        # being modified:
        temp_file = File.join('/tmp', "#{ File.basename(log_filename) }")
        puts "Making a temp. copy on #{temp_file}..."
        sh "cp #{log_filename} #{ temp_file }"
        puts "Archiving contents..."
        sh "tar --bzip2 -cf #{File.basename(log_filename, '.log') + time_signature + '.log.tar.bz2'} #{temp_file}"
        puts "Removing temp. file..."
        FileUtils.rm( temp_file )
        # (We'll leave the tar file just created under the log dir, so that the #rotate_backups
        #  will be able to treat it properly.)
      end
    end
    Dir.chdir( Dir.pwd.to_s )
    puts "Truncating all current log files..."
    Rake::Task['app:log:clear'].invoke
    Rake::Task['app:utils:clear_output'].invoke
                                                    # Rotate the backups leaving only the newest ones: (log files are 3-times normal backups)
    rotate_backups( backup_folder, max_backups * 3 )
    puts "Done.\r\n\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++


desc <<-DESC
Creates a tar(bz2) dump file for the whole subtree of the application.

    Options: [app_version=#{APP_VERSION}] [output_dir=#{TAR_BACKUP_DIR}]
DESC
  task :tar => ['app:build:log_rotate'] do
    puts "*** Task: Tar BZip2 Application Backup ***"
                                                    # Prepare & check configuration:
    backup_folder = ENV.include?("output_dir") ? ENV["output_dir"] : TAR_BACKUP_DIR
    app_version   = ENV.include?("app_version") ?
                    ENV['app_version'] + '.' + Date.today.strftime("%Y%m%d") :
                    APP_VERSION + '.' + DateTime.now.strftime("%Y%m%d.%H%M")
    file_name     = APP_NAME + '-' + app_version + '.tar.bz2'
    FileUtils.makedirs(backup_folder) if ENV.include?("output_dir") # make sure overridden output folder exists, creating the subtree under app's root

# TODO [FUTUREDEV] parametrize sessions cleanup
    Rake::Task['app:db:sessions:clear'].invoke
# TODO [FUTUREDEV] parametrize temp dir cleanup
    Rake::Task['app:tmp:clear'].invoke

    puts "Creating #{file_name} under #{backup_folder}."
    Dir.chdir( backup_folder )
    sh "tar --bzip2 -cf #{file_name} #{Dir.pwd}"
    Dir.chdir( Dir.pwd.to_s )

    puts "Done.\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++


desc <<-DESC
Updates the current versioning numbers inside DB table app_parameters.

    Options: [app_version=#{APP_VERSION}] [db_version=<db_struct_version>]
             [Rails.env=#{Rails.env}]
DESC
  task :version => [:environment, 'app:utils:script_status'] do
    puts "Updating current version number..."
                                                    # Prepare & check configuration:
    time_signature = Date.today.strftime("%Y%m%d")
    db_version    = ENV.include?("db_version") ? ENV['db_version'] + '.' + time_signature : nil
    app_version   = ENV.include?("app_version") ?
                    ENV['app_version'] + '.' + time_signature : APP_VERSION
                                                    # Update DB struct versioning number inside table app_parameter:
    ap = AppParameter.find(:first, :conditions => "code=1")
    unless ap.nil? || ap == []
      ap.update_attribute( :a_string, db_version ) unless db_version.nil?
      ap.update_attribute( :a_name, app_version )
    else
      raise "\r\nError: AppParameter row with code==1 is missing from the DB!"
    end
    puts "Base Versioning update: done."
  end
  #-- -------------------------------------------------------------------------
  #++

desc <<-DESC
Updates the News log table with an entry stating that the application has been updated.

    Options: [app_version=#{APP_VERSION}] [db_version=<db_struct_version>]
             [Rails.env=#{Rails.env}]
DESC
  task :news_log => ['app:build:version'] do
                                                    # Prepare & check configuration:
    time_signature = Date.today.strftime("%Y%m%d")
    db_version    = ENV.include?("db_version") ? ENV['db_version'] + '.' + time_signature : nil
    app_version   = ENV.include?("app_version") ? ENV['app_version'] + '.' + time_signature : APP_VERSION

    puts "Logging the update into the news blog..."
    Article.create({
      title: "Aggiornamento dell'applicazione",
# TODO [FUTUREDEV] Localize this
      body:  "L'applicazione e' stata aggiornata e portata alla versione " + app_version +
             (db_version.nil? ? "" : ". La struttura del DB e' stata portata alla versione " + db_version) + ".",
      user_id: 1 # default user id (must be not null)
    })
    puts "NewsLog update: done."
  end
  #-- -------------------------------------------------------------------------
  #++


desc <<-DESC
Creates a local build (with release info, backup and current DB dump).

This complex task updates the internal versioning number for the DB and the
application framework, then saves the log files, updates and dumps the DB (in
case of a new version) and, finally, stores the local build inside a backup
tar file.

    Options: app_version=<application_version> [db_version=<db_struct_version>]
             [Rails.env=#{Rails.env}]
DESC
  task :local => ['app:build:news_log','app:build:tar','app:sql:dump'] do
    puts "BUILD: LOCAL: done."
  end
  #-- -------------------------------------------------------------------------
  #++
end
# ==============================================================================



namespace :utils do

  desc "Outputs current script version and working status"
  task(:script_status) do
    puts "\r\n===  local_deploy.rake script - vers. #{SCRIPT_VERSION}  ==="
    puts "Written by Stefano Alloro, FASAR Software 2007-2013\r\n\r\n"
    puts 'Application: ' + APP_NAME if defined? APP_NAME
    puts 'Evironment:  ' + Rails.env
    puts 'Working in:  ' + Dir.pwd
    puts "\r\n- Framework vers. : #{APP_VERSION}"
    puts "- MAX_BACKUP_KEPT : #{MAX_BACKUP_KEPT}"
    puts "- DB_BACKUP_DIR   : #{DB_BACKUP_DIR}"
    puts "- TAR_BACKUP_DIR  : #{TAR_BACKUP_DIR}"
    puts "- LOG_BACKUP_DIR  : #{LOG_BACKUP_DIR}"
    puts "- ODT_OUTPUT_DIR  : #{ODT_OUTPUT_DIR}"
    puts "- UPLOADS_DIR     : #{UPLOADS_DIR}"
    puts "- DB_SEED_DIR     : #{DB_SEED_DIR}"

    puts ""
  end
  #-- -------------------------------------------------------------------------
  #++

  desc "Check and creates missing needed directories"
  task(:chk_needed_dirs) do                         # Check the needed folders & create if missing:
    for folder in NEEDED_DIRS
      puts "Checking existance of #{folder} (and creating it if missing)..."
      FileUtils.mkdir_p(folder) if !File.directory?(folder)
    end
    puts "\r\n"
  end
  #-- -------------------------------------------------------------------------
  #++

  desc "Clears the app 'output' directory (if existing) contained inside /public."
  task(:clear_output) do
    if File.directory?(ODT_OUTPUT_DIR)              # Output Directory found existing?
      puts "Clearing temp output directory..."
      FileUtils.rm( Dir.glob("#{ODT_OUTPUT_DIR}/*") )
    else                                            # Processing a file?
      puts "Temp output directory not found, nothing to do."
    end
    puts 'Done.'
  end


  desc "Clears the app 'uploads' directory (if existing) contained inside /public."
  task(:clear_uploads) do
    if File.directory?(UPLOADS_DIR)                 # Uploads Directory found existing?
      puts "Clearing temp uploads directory..."
      FileUtils.rm( Dir.glob("#{UPLOADS_DIR}/*") )
    else                                            # Processing a file?
      puts "Temp uploads directory not found, nothing to do."
    end
    puts 'Done.'
  end
  #-- -------------------------------------------------------------------------
  #++
end
# ==============================================================================
