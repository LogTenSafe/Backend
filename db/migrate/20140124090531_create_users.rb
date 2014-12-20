class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :crypted_password, :pepper, null: false, limit: 128
      t.timestamps null: false
    end

    change_table :users do |t|
      t.index :login, unique: true
    end
  end
end
