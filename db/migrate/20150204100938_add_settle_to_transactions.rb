class AddSettleToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :settle, :boolean
  end
end
