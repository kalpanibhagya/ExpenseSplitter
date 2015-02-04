class Event < ActiveRecord::Base
  has_many :participates
  has_many :users, through: :participates
  has_many :transactions


  def participate_attributes=(participate_attributes)
    participate_attributes.each do |attributes|
      participates.build(attributes)
	end
  end
end
