class Transaction < ActiveRecord::Base
	belongs_to :event
	belongs_to :sender, :class_name => "User"
	belongs_to :receiver, :class_name => "User"

  def self.save_all(transactions)
    ActiveRecord::Base.transaction do
      transactions.each do |transac|
        transac.save
        notification = Notification.get_transaction_notification(transac)
        notification.save
      end
    end
  end
end
