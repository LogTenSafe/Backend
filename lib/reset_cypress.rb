# frozen_string_literal: true

# Rack application that an endpoint allowing the Cypress front-end to reset the
# database before each E2E test run. Only mounted in the `cypress` environment.

class ResetCypress

  # @private
  def call(env)
    req = Rack::Request.new(env)
    reset(skip_backup: req.query_string == "skip_backup")
    return response
  end

  private

  def reset(skip_backup: false)
    models.each { truncate _1 }
    add_fixtures(skip_backup:)
    reset_emails
  end

  def response = [200, {"Content-Type" => "text/plain"}, ["Cypress reset finished"]]

  def models = [ActiveStorage::Blob, ActiveStorage::Attachment, *ApplicationRecord.subclasses]

  def truncate(model)
    model.connection.execute "TRUNCATE #{model.quoted_table_name} CASCADE"
  end

  def add_fixtures(skip_backup: false)
    User.create!(email:                 "cypress@example.com",
                 password:              "password123",
                 password_confirmation: "password123")

    return if skip_backup

    backup = Backup.new(user: User.first, hostname: "localhost")
    backup.logbook.attach io:       Rails.root.join("spec", "fixtures", "LogTenCoreDataStore.sql").open,
                          filename: "LogTenCoreDataStore.sql"
    backup.save!
  end

  def reset_emails
    Dir.glob(maildir.join("*").to_s).each { FileUtils.rm _1 }
  end

  def maildir = Rails.root.join("tmp", "mails")
end
