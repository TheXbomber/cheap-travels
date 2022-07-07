class AddFavouritesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :favourites, :string
  end
end
