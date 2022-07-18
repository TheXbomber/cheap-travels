class AddDefaultValuesToUserAttribute < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :role, :string, default: "user"
    change_column :users, :banned, :boolean, default: false
    change_column :users, :favourites, :string, default: ""
  end
end
