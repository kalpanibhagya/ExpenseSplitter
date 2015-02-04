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

end
