class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.belongs_to :user, null: false

      #t.attachment :logbook
      t.string :logbook_file_name, :logbook_content_type, :logbook_fingerprint, null: false
      t.integer :logbook_file_size, null: false
      t.datetime :logbook_updated_at, null: false

      t.date :last_flight_date
      t.text :last_flight
      t.decimal :total_hours, null: false, precision: 7, scale: 1

      t.string :hostname, limit: 128

      t.timestamps null: false
    end

    change_table :backups do |t|
      t.index [:user_id, :last_flight_date]
      t.index [:user_id, :created_at]
      t.index [:user_id, :total_hours]
      t.index [:user_id, :logbook_fingerprint], unique: true
    end
  end
end
