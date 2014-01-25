# Methods in this module are available to all views in the application.

module ApplicationHelper

  # Returns whether a given navigation tab should be shown as active.
  #
  # @param [Symbol] tab The tab in question (e.g. `:account`).
  # @return [true, false] If that tab should be active.

  def active_tab?(tab)
    case tab
      when :backups
        controller_name == 'backups'
      when :account
        controller_name == 'account'
    end
  end
end
