require 'active_record'
require 'active_support/all'
require 'logger'
require 'pathname'
require 'yaml'

env = ENV['ENV'] || :development
DB_CONFIG = YAML.load_file(File.expand_path('../database.yml', __FILE__))

class App
  def self.files_path
    @files_path ||= self.project_path.join 'files'
  end

  def self.project_path
    @project_path ||= Pathname.new File.expand_path '../..', __FILE__
  end

  def self.relative_project_path(path)
    Pathname.new(path).relative_path_from(self.project_path)
  end

  def self.results_path
    @results_path ||= self.project_path.join 'results'
  end
end

ActiveRecord::Base.configurations = DB_CONFIG
ActiveRecord::Base.establish_connection env.to_sym
ActiveRecord::Base.logger = Logger.new STDOUT if DB_CONFIG['logger']

# recursively require all files in "app" folder
Dir.glob(File.expand_path('../../app/**/*.rb', __FILE__)).each do |file|
  require file
end