require 'rails/generators'

class AttributedMigrationGenerator < Rails::Generators::Base

  def create_migration_file
    create_file "db/migrate/#{Time.zone.now.strftime("%Y%m%d%H%M%S")}_attributed_migration_1_0_0.rb", migration_data
  end

  private

  def migration_data
<<MIGRATION
class AttributedMigration100 < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :items
      create_table :items do |t|
        t.string :name

        t.timestamps
      end
    end

    unless table_exists? :attributes_lists
      create_table :attributes_lists do |t|
        t.bigint :item_id
        t.bigint :attributable_id
        t.string :attributable_type
        t.text :authorized_attributes

        t.timestamps
      end
    end
  end
end
MIGRATION
  end
end
