class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :receiver_id, index: true
      t.integer :sender_id
      t.text :message
      t.boolean :read
      t.text :link
      t.timestamps
    end
  end
end
