class CreatePageViews < ActiveRecord::Migration
  def change
    create_table :page_views do |t|
      t.string :item_type
      t.integer :item_id
      t.string :period_type
      t.integer :page_view

      t.timestamps
    end

    add_index :page_views, [:item_type, :item_id, :period_type], unique: true
  end
end
