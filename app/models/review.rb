class Review < ApplicationRecord
	belongs_to :user

	def rating_valid
		error.add(:rating, 'deve essere compreso tra 1 e 5') if rating<0 || rating>5
	end

	def place_valid
		error.add(:place, 'il luogo non può contenere numeri') if place.match? /0|1|2|3|4|5|6|7|8|9/
	end

	validates :user_id, :presence=>true
	validates :place, :presence=>true
	validate :place_valid
	validates :rating, :presence=>true
	validate :rating_valid
	validates :body, :presence=>true
end
