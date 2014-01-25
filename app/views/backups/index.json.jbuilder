json.array! @backups do |backup|
  json.logbook do
    json.fingerprint backup.logbook_fingerprint
    json.size backup.logbook_file_size
    json.url backup.logbook.url(:default, host: request.host)
  end

  json.created_at backup.created_at
  json.last_flight_date backup.last_flight_date
  json.last_flight backup.last_flight
  json.total_hours backup.total_hours.to_f
  json.hostname backup.hostname
  json.download_url backup_url(backup, format: 'gz')
end
