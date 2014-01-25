LogTenSafe
==========

LogTenSafe is a combination of a website (this repository) and Mac OS X
[client library](https://github.com/LogTenSafe/MacOSX) that watches a LogTenPro
database for changes, and periodically uploads it.

LogTenSafe was created as a way for pilots to take a more active involvement in
the backup and restore of their logbooks than iCloud backup allows.

Documentation for LogTenSafe is available by running `rake yard`. Resulting
documentation is stored in the `doc/app` directory.

Getting Started
---------------

LogTenSafe requires Ruby 1.9+, the Bundler gem, PostgreSQL, the SQLite developer
libraries and headers, and libxml.

1. After cloning the repository, run `bundle install` to install all necessary
   gems.
2. Create a new PostgreSQL user called `LogTenSafe`.
3. Create two databases owned by that user, `LogTenSafe_development` and
   `LogTenSafe_test`.
4. Run `rake db:migrate` to set up the development database.
5. Run `rake db:migrate RAILS_ENV=test` to set up the test database.

You can now run `rspec spec` to verify that the website functions correctly. Run
`rails server` to start a server locally on port 3000.

Before beginning development, you may need to customize certain configuration
options, especially those in the `config/environments/common/secrets.yml` file.

Architecture
------------

LogTenSafe is a basic Ruby on Rails website. Configuration variables are stored
and managed using [Configoro](https://github.com/RISCfuture/Configoro).

### Models

Logbook data is stored using
[Paperclip](https://github.com/thoughtbot/paperclip). In development mode,
logbook files are stored locally in `public/system`. In production mode, they
are stored using S3. Paperclip provides normalized access to these files using
the `Paperclip.io_adapters` method.

Pagination is handled by Kaminari.

### Authentication

Users can be authenticated to the website using either a normal cookie-based
session from a login-password form submission, or HTTP Basic authentication for
API requests. Authentication is handled by the `Authentication` controller
mixin.

### Views

HTML views are rendered using Slim and Sass.  JSON views are rendered using
JBuilder. The `field_error_proc.rb` and `form_with_errors.js.coffee` modules
work together to surface model errors to view forms.

LogTenSafe is built using vanilla Bootstrap. Small tweaks have been made to the
CSS to use Rails's `asset-url` method.

Deployment
----------

Deployment is done with Capistrano. A production box must have
`config/environments/production/secrets.yml` and `config/database.yml` files
placed into the shared directory before deploying.
