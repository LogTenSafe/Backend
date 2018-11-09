json.array! @backups do |backup|
  json.logbook do
    json.size backup.logbook.byte_size
    json.url url_for(backup.logbook)
  end

  json.created_at backup.created_at
  json.last_flight backup.last_flight
  json.total_hours backup.total_hours
  json.hostname backup.hostname
  json.download_url backup_url(backup, format: 'sql')

  json.logbook do
    json.size backup.logbook.byte_size
  end if backup.logbook.attached?

  # LEGACY
  json.last_flight_date backup.last_flight&.fetch('date')
end
