class AddPlaceToReview < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :place, :string
  end
end
