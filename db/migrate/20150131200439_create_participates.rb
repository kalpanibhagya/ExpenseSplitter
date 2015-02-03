class CreateParticipates < ActiveRecord::Migration
  def change
    drop_table :participates
    
    create_table :participates do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
      t.decimal :amount
      t.decimal :portion
      t.timestamps
    end
  end
end