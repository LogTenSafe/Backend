class RemovePaperclipFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :backups, :logbook_file_name
    remove_column :backups, :logbook_content_type
    remove_column :backups, :logbook_fingerprint
    remove_column :backups, :logbook_file_size
    remove_column :backups, :logbook_updated_at

    remove_column :backups, :last_flight
    remove_column :backups, :last_flight_date
    remove_column :backups, :total_hours
  end
end
