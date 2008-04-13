class CreateTaxes < ActiveRecord::Migration
  def self.up
    create_table :taxes do |t|
      t.integer :task_id
      
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :taxes
  end
end
