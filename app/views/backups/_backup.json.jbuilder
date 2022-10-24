# frozen_string_literal: true

json.call backup, :id, :created_at, :hostname, :last_flight, :total_hours

json.logbook do
  json.size backup.logbook.byte_size
  json.analyzed(backup.logbook.analyzed? == true)
end

json.download_url polymorphic_url(backup.logbook)
json.destroyed backup.destroyed?

if defined?(include_pagination) && include_pagination
  json.total backup.user.backups.analyzed.count
end
