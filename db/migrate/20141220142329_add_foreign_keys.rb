class AddForeignKeys < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :backups, :users
  end
end
