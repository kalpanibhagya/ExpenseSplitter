class FriendshipsController < ApplicationController
  def create
    
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend added."
      redirect_to profile_all_path
     else       
      flash[:notice] = "Unable to add friend"
     end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to profile_all_path
  end
end
