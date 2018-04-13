Backup.find_each do |backup|
  puts "Copying backup #{backup.id}…"

  backup_path = 'production/backups/'
  backup_path << backup.id.to_s.rjust(9, '0').chars.each_slice(3).map(&:join).join('/')
  backup_path << '/logbooks/LogTenCoreDataStore.sql'
  object = ActiveStorage::Blob.service.bucket.object(backup_path)

  download_path = Rails.root.join('tmp', "backup-#{backup.id}.sql")
  download_path.open('wb') { |f| f.write object.get.body.read }

  backup.logbook.attach io: download_path.open, filename: download_path.basename, content_type: 'application/x-sqlite3'

ensure
  download_path.unlink if download_path&.exist?
end
