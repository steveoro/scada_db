# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"


rspec_options = {
    # This option must match the path in engine_plan.rb
    results_file: 'tmp/guard_rspec_results.txt',

    # Run any spec using zeus as a pre-loader, excluding profiling/performance specs:
    cmd: "zeus rspec -f progress -t ~type:performance",

    all_after_pass: false,
    failed_mode: :focus
}


require 'pry'

Pry::Commands.block_command 't', "Touch files in specified path (usage: 't path_name_with_wildchars')" do |file_path|
  output.puts "Updating modification time for files under '#{file_path}'..."
  system( "touch -m #{file_path}" )
end

                                                    # === Main watch group: ===
group :rspec do
    guard :rspec, rspec_options do
      # Watch support and config files:
      watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
      watch('spec/spec_helper.rb')                        { "spec" }
      watch('spec/rails_helper.rb')                       { "spec" }
      watch('config/routes.rb')                           { "spec/routing" }
      watch('app/controllers/application_controller.rb')  { "spec/controllers" }
      watch(%r{^spec\/support\/(.+)\.rb$})                { "spec" }
    
      # Watch any spec files for changes:
      watch( %r{^spec\/.+_spec\.rb$} )
    
      # Watch factories and launch the specs for their corresponding model:
      watch( %r{^spec\/factories\/(.+)\.rb$} ) do |m|
        Dir[ "spec/models/scada_db/#{m[1]}*spec.rb" ]
      end
    
      # Watch app sub-sub-dirs and spawn a corresponding spec re-check:
      watch( %r{^app\/(.+)\/(.+)\.rb$} ) do |m|
        Dir[ "spec/#{m[1]}/#{m[2]}*spec.rb" ]
      end
    
      # Watch dummy app files:
      watch(%r{^spec/dummy/app\/(.+)\/(.+)\.rb$}) do |m|
    # DEBUG
    #    puts "Paths: '#{m.inspect}'"
        "spec/dummy/spec/#{m[1]}/#{m[2]}_spec.rb"
      end
    end
end

                                                    # === Specific Scopes: ===
group :model do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:model',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :controller do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:controller',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :strategy do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:strategy',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :service do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:service',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :request do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:request',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :acceptance do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:acceptance',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :mailer do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:mailer',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :helper do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:helper',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end
group :feature do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:feature',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: true,
        failed_mode: :focus
end

group :integration, halt_on_fail: true do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:integration',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: false,
        failed_mode: :focus
end

group :performance, halt_on_fail: true do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:performance',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: false,
        failed_mode: :focus
end


# Define default group with scope command:
scope group: :rspec
