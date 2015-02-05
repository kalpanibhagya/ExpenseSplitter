class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  has_many :participates
  has_many :events, through: :participates
  
  has_many :friendships
  has_many :friends, :through => :friendships

  def name
    self.first_name + " " + self.last_name
  end

  def self.search(search,ids)
    if(search == nil || search.length == 0)
      if(ids != nil && ids.length >= 1)
        user_id = ids[0,1]
        find(user_id).friends
      end
    else
      input = "%#{search}%"
      # search for friends of already added user_ids.
      # disabled because of duplicate result retrive
      # if(ids != nil && ids.length >= 1)
      #   id_array = ids.split(',')
      #   results = Array.new
      #   find(id_array).each do |friend|
      #     friend.friends.each do |result|
      #       results.push(result)
      #     end
      #   end
      #   results
      # else
      #   # normal name search
      #   where('email LIKE ? OR first_name LIKE ? OR last_name like ?', input,input,input)
      # end
      # disabled ends

      where('email LIKE ? OR first_name LIKE ? OR last_name like ?', input,input,input)
    end    
  end
end
