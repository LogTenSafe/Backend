json.call backup, :id, :created_at, :hostname, :last_flight, :total_hours

json.logbook do
  json.size backup.logbook.byte_size
  json.analyzed(backup.logbook.analyzed? == true)
end

json.download_url url_for(backup.logbook)
json.destroyed backup.destroyed?
