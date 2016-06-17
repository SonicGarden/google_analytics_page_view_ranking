require 'rails/generators'
require 'rails/generators/migration'

module GoogleAnalyticsPageViewRanking
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_model_file
      migration_template "create_page_views.rb", "db/migrate/create_page_views.rb"
    end
  end
end
