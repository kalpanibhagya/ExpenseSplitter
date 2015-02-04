class CreateTransactions < ActiveRecord::Migration
  def change
    drop_table :transactions

    create_table :transactions do |t|
      t.belongs_to :event, index: true
      t.integer :sender_id, index: true
      t.integer :receiver_id
      t.decimal :amount
      t.timestamps
    end
  end
end