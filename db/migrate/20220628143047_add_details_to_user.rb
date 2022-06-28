class AddDetailsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :bday, :date
    add_column :users, :tel, :string
    add_column :users, :role, :string
    add_column :users, :banned, :boolean
  end
end
