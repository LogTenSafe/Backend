# LogTenSafe: Rails Back-End

LogTenSafe is a website (at logtensafe.com) and a macOS application that backs
up logbook data from [LogTen Pro](https://coradine.com), in case iCloud sync
poops the bed, or some other unforeseen badness happens.

This project is the back-end for the LogTenSafe website. The back-end is
powered by Ruby on Rails. It is an API-only back-end, with the front-end and
application being in entirely separate repositories. This back-end stores user
and backup data, and renders API responses and WebSocket connections.

## Installation and Usage

LogTenSafe is a straightforward API-only Rails site. The targeted Ruby version
is in `.ruby-version`. Run `brew install` to install all other required
dependencies with Homebrew (or inspect the contents of `Brewfile` manually),
then run `bundle install` to install all required gems.

You will also need to generate your own `credentials.yml.enc` and `master.key`
files using the `rails credentials:edit` task. The YAML should be of the
following format:

``` yaml
secret_key_base:

aws:
  access_key_id:
  secret_access_key:

bugsnag_api_key:

devise:
  key_base:
  jwt_secret_key:
```

Run `rails server` to run the back-end server. Note that the front-end expects
the back-end to be running on port 5000 in development, for the development
proxy to work. Run `bin/cable` to start the WebSockets server on port 28080.

YARD documentation is generated to the `doc/` directory by running `rails yard`.

## Architecture

The LogTenSafe back-end stores user and backup data, analyzes logbook data, and
exposes that information via HTTP and WebSockets APIs.

### Models

There are two models in LogTenSafe, {User} and {Backup}. A User has many
Backups, one for each logbook that is uploaded. A validation on Backup ensures
that duplicate logbooks are not uploaded twice.

#### Data Store

After being uploaded, the logbook is stored to AWS using Active Storage. The
{LogbookAnalyzer} Active Storage analyzer loads the logbook using SQLite, and
performs queries to calculate a summary of the logbook data, which is saved to
the blob metadata.

### Jobs

Offline processing is powered by Sidekiq. There are no application-specific
jobs, only the default jobs that perform Active Storage analysis, etc.

### API

This website exposes a JSON API for getting user and backup information, and
uploading or deleting backups. Downloading backups is also possible using the
expiring URL system exposed by Active Storage.

#### Authorization

Authorization is handled by Devise, which provides the routes for signing up,
logging in, retrieving passwords, etc.

Authorization is mediated using JSON Web Tokens (JWT). When a user logs in, the
response will have an `Authorization` header containing the JWT. That JWT can be
used in the `Authorization` header of subsequent requests to authenticate those
requests, until it expires.

#### WebSockets

By making an HTTP Upgrade request to `/cable` on the WebSockets server, the
client can open a connection Action Cable. Action Cable has one channel,
`BackupsChannel`, which streams any additions, deletions, or changes to the
user's list of backups.

The WebSockets must be authenticated using the JWT, passed as a query parameter
to `/cable`.

## Testing

Unit tests are written using RSpec, and can be run by executing `rspec spec`.
E2E tests are handled by the front-end.
