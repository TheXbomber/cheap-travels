class Review < ApplicationRecord
	belongs_to :user

	def rating_valid
		error.add(:rating, 'deve essere compreso tra 1 e 5') if rating<0 || rating>5
	end

	validates :user_id, :presence=>true
	validates :place, :presence=>true
	validates :rating, :presence=>true
	validate :rating_valid
end
