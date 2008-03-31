class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.integer :task_id
      
      t.timestamp :start_time
      t.timestamp :end_time
      t.text :notes
      t.text :after_notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :time_entries
  end
end
