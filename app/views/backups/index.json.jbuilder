json.array!(@backups) do |backup|
  json.partial! 'backups/backup', locals: {backup:}
end
