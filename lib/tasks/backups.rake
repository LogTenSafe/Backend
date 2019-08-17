namespace :backups do
  desc "Remove all but the 50 most recent backups for each user"
  task purge: :environment do
    User.find_each do |user|
      keep = user.backups.order('created_at DESC').limit(50)
      user.backups.destroy_by('id NOT IN (?)', keep.pluck(:id))
      # need to destroy_all to also delete paperclip attachments
    end
  end
end
