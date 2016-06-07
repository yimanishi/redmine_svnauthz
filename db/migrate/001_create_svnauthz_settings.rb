class CreateSvnauthzSettings < ActiveRecord::Migration
  def self.up
    create_table :svnauthz_settings do |t|
      t.integer :project_id
      t.string :directory
      t.string :permission
      t.boolean :group_flag
    end
  end

  def self.down
    drop_table :svnauthz_settings
  end
end
