# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
Mime::Type.register 'application/gzip', :gz

mime = MIME::Type.new('application/x-sqlite3')
mime.extensions << 'sql' << 'db'
MIME::Types.add mime
