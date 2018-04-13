# RESTful controller for {Backup} instances. Both the API controller that the
# uploader software uses, and the controller end-users use to browse backups.

class BackupsController < ApplicationController
  include Streaming

  before_action :find_backup, except: [:index, :create]
  skip_before_action :verify_authenticity_token, only: :create

  respond_to :html, :json, except: :show
  respond_to :gz, only: :show

  # Displays a list of backups, 50 at a time. Pagination information is stored
  # in the `X-Page` and `X-Pages` headers.

  def index
    @backups = current_user.backups.order('created_at DESC')
    respond_with @backups
  end

  # Downloads a backup.

  def show
    respond_with @backup do |format|
      format.gz do
        if @backup.logbook.attached?
          stream @backup.logbook.service_url
        else
          head :not_found
        end
      end
    end
  end

  # Creates a new backup.

  def create
    @backup = current_user.backups.create(backup_params)
    respond_with @backup, location: backups_url
  end

  # Deletes a backup and its associated file.

  def destroy
    @backup.destroy
    flash[:notice] = t('controllers.backups.destroy.success')
    respond_with @backup, location: backups_url
  end

  private

  def find_backup
    @backup = current_user.backups.find_by_id!(params[:id])
  end

  def backup_params
    params.require(:backup).permit(:logbook, :hostname)
  end
end
