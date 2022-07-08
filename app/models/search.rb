class Search
  include ActiveModel::Model
  attr_accessor :origin
  validates :origin, presence: true
end
