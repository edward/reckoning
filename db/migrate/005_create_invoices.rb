class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :client_id
      
      t.text :notes
      t.timestamp :sent_at
      t.timestamp :paid_at
      t.boolean :invalidated
      
      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
