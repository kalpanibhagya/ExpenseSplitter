class Notification < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"

  def self.add_notification(sender,receiver,message,link)
    if(receiver != nil)
      notification = Notification.new
      notification.sender = sender
      notification.receiver = receiver
      notification.message = message
      notification.read = false
      notification.link = link

      notification.save
    end

  end

  def self.get_transaction_notification(transaction)
    notification = Notification.new
    notification.sender = transaction.receiver
    notification.receiver = transaction.sender
    formated_amount = format_amount(transaction.amount)
    notification.message = "Pay me an amount of #{formated_amount} for the event \"#{transaction.event.name}\""
    notification.read = false
    notification.link = get_link(transaction.event)
    notification
  end

  def self.get_link(event)
    if (event != nil)
      link = "event/#{event.id}"
    else
      link = nil
    end    
  end

  def self.format_amount(float)
    sprintf("%05.2f", float)
  end
end
