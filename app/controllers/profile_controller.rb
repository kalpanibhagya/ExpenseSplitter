class ProfileController < ApplicationController
  
  def show
    @user = current_user
    if(@user == nil)
      redirect_to profile_index_path
    else

      user_id = current_user.id

      @debts =  Event.joins(:transactions).where('transactions.sender_id = ? AND transactions.settle= ?',user_id,false).order(created_at: :desc).group('event_id')
      @spents =  Event.joins(:transactions).where('transactions.receiver_id = ? AND transactions.settle= ?',user_id,false).order(created_at: :desc).group('event_id')
      @settlements =  Event.joins(:transactions).where('(transactions.sender_id = ? OR transactions.receiver_id = ?) AND transactions.settle= ?',user_id,user_id,true).order(created_at: :desc).group('event_id')
    end
  end
  
  def all
    @logged_user = current_user
    @users = User.all
    
    @user_friends = @logged_user.friends
    
    @new_friends = Array.new
    
    @users.each do |user|
     new_friend = true
     
     if(@logged_user.email == user.email)
       new_friend =false;
     end
     
     if(new_friend == true)
       @user_friends.each do |friend|
         if(user.email == friend.email)
           new_friend = false	    
         end
       end
     end
     
     if(new_friend == true)
       @new_friends.push(user)
     end
     
   end
 end
end
