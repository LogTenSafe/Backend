# frozen_string_literal: true

# RESTful API controller for a {User}'s {Backup} records.

class BackupsController < ApplicationController
  PER_PAGE = 50
  private_constant :PER_PAGE

  before_action :find_backup, except: %i[index create]

  respond_to :json

  # Renders a paginated list of the user's Backups, for use with infinite
  # scrolling.
  #
  # ## Routes
  #
  # * `GET /backups.json`

  def index
    @backups = current_user.backups.
        analyzed.
        order(created_at: :desc).
        limit(PER_PAGE).
        with_attached_logbook

    @backups = paginate(@backups)

    respond_with @backups
  end

  # Renders the information for a single Backup.
  #
  # ## Routes
  #
  # * `GET /backups/:id.json`
  #
  # ## Path Parameters
  #
  # |      |                       |
  # |:-----|:----------------------|
  # | `id` | The ID of a {Backup}. |

  def show = respond_with @backup

  # Creates a Backup from the given parameters.
  #
  # ## Routes
  #
  # * `POST /backups.json`
  #
  # ## Body Parameters
  #
  # |          |                                                                                                      |
  # |:---------|:-----------------------------------------------------------------------------------------------------|
  # | `backup` | A parameterized hash of {Backup} attributes. `backup[logbook]` must be a multipart file data stream. |

  def create
    return if validate_logbook_duplicate

    @backup = current_user.backups.create(backup_params)
    respond_with @backup, location: backups_url
  end

  # Deletes a Backup.
  #
  # ## Routes
  #
  # * `GET /backups/:id.json`
  #
  # ## Path Parameters
  #
  # |      |                       |
  # |:-----|:----------------------|
  # | `id` | The ID of a {Backup}. |

  def destroy
    @backup.destroy
    respond_with @backup, location: backups_url
  end

  private

  def find_backup
    @backup = current_user.backups.find(params[:id])
  end

  def backup_params = params.require(:backup).permit(:logbook, :hostname)

  def validate_logbook_duplicate
    logbook = backup_params[:logbook] or return false

    checksum = ActiveStorage::Blob.new.send(:compute_checksum_in_chunks, logbook.to_io)
    backup = current_user.backups.
        joins(logbook_attachment: :blob).
        where(ActiveStorage::Blob.arel_table[:checksum].eq(checksum)).
        first or return false

    respond_with(@backup = backup)
    return true
  end
end
