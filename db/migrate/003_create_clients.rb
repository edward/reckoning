class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.column :default_rate, :decimal, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
