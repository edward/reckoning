class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :invoice_id
      t.integer :project_id
      
      t.string :name
      t.column :rate, :decimal, :precision => 8, :scale => 2
      t.text :notes
      t.integer :time_estimate #in seconds
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
