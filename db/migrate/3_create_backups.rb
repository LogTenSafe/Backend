class CreateBackups < ActiveRecord::Migration[6.0]
  def change
    create_table :backups do |t|
      t.belongs_to :user, null: false
      t.string :hostname

      t.timestamps
    end
  end
end
