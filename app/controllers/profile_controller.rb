class ProfileController < ApplicationController
  
  def show
    @user = current_user
    if(@user == nil)
      redirect_to profile_index_path
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
