class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :backups, :users
  end
end
