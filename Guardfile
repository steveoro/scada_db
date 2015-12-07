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
  results_file: 'tmp/guard_rspec_results.txt', # This option must match the path in engine_plan.rb
  # Run any spec using zeus as a pre-loader, excluding profiling/performance specs:
  cmd: "zeus rspec -f progress -t ~type:performance",
  all_after_pass: false,
  failed_mode: :focus
}


group :performance do
  guard :rspec, cmd: 'zeus rspec -f progress -t type:performance',
        results_file: 'tmp/guard_rspec_results.txt',
        all_after_pass: false
end


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
