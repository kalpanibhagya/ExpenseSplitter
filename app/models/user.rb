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

  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      :all
    end
  end
end
