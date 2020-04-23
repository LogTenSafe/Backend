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
  #
  # ## Response Headers
  #
  # |               |                                                                      |
  # |:--------------|:---------------------------------------------------------------------|
  # | `X-Next-Page` | The URL for the next page of backups. Not provided on the last page. |

  def index
    @backups = current_user.backups.
        joins(logbook_attachment: :blob).
        where(%(metadata::text LIKE '%\\\\"analyzed\\\\":true%')). #TODO do better than this :/
        order(created_at: :desc).
        limit(PER_PAGE).
        with_attached_logbook

    if params[:before].present?
      before   = begin
                   Time.parse(params[:before])
                 rescue Date::Error
                   nil
                 end
      @backups = @backups.where(Backup.arel_attribute(:created_at).lt(before)) if before
    end

    #TODO created_at isn't guaranteed unique
    @last_page                      = @backups.empty? || @backups.pluck(:created_at).include?(Backup.minimum(:created_at))
    response.headers['X-Next-Page'] = backups_url(before: @backups.last.created_at.xmlschema, format: params[:format]) unless @last_page

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

  def show
    respond_with @backup
  end

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

  def backup_params
    params.require(:backup).permit(:logbook, :hostname)
  end

  def validate_logbook_duplicate
    logbook = backup_params[:logbook] or return false

    checksum = ActiveStorage::Blob.new.send(:compute_checksum_in_chunks, logbook.to_io)
    backup = current_user.backups.
        joins(logbook_attachment: :blob).
        where(ActiveStorage::Blob.arel_attribute(:checksum).eq(checksum)).
        first or return false

    respond_with(@backup = backup)
    return true
  end
end
