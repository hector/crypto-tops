# https://gist.github.com/drogus/6087979

require 'bundler/setup'
require 'active_record'

# FIX FOR ACTIVE RECORD TASKS

module Rails
  def self.root
    File.dirname(__FILE__)
  end

  def self.env
    ENV['APP_ENV']
  end

  def self.application
    Paths.new
  end
end

class Paths
  def paths
    { "db/migrate" => [File.expand_path("../db/migrate", __FILE__)] }
  end

  def load_seed
    load File.expand_path("../db/seeds.rb", __FILE__)
  end
end

# END FIX FOR ACTIVE RECORD TASKS

include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['ENV'] || :development
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load_file(File.join(config_dir, 'database.yml'))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  require_relative 'config/environment'
end

load 'active_record/railties/databases.rake'

# Load custom tasks
Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each { |r| import r }