# [Steve A., 20151012]
#
# This file allows the customized execution of Zeus for the current Engine setup.
#
# Zeus is a wonderful pre-loader for Rails that speeds-up the bootstrap of any
# Rails environment.
#
# Keep in mind that Zeus should be installed locally as it doesn't need to be
# included as a dependancy on the Gemfile.
# (Simply do a: "> gem i zeus" on the console)
#
# For more info: https://github.com/burke/zeus
#
require 'zeus/rails'

ROOT_PATH = File.expand_path(Dir.pwd)
ENV_PATH  = File.expand_path('spec/dummy/config/environment',  ROOT_PATH)
BOOT_PATH = File.expand_path('spec/dummy/config/boot',  ROOT_PATH)
APP_PATH  = File.expand_path('spec/dummy/config/application',  ROOT_PATH)
ENGINE_ROOT = File.expand_path(Dir.pwd)
ENGINE_PATH = File.expand_path('lib/scada_db/engine', ENGINE_ROOT)


class EnginePlan < Zeus::Rails
  def test(*args)
    ENV['GUARD_RSPEC_RESULTS_FILE'] = 'tmp/guard_rspec_results.txt' # can be anything matching Guard::RSpec :results_file option in the Guardfile
    super
  end
end


ENV["RAILS_ENV"] = 'test'
Zeus.plan = EnginePlan.new
