require 'uri'

# @private
class URI::Generic

  # @private
  def host_with_port
    port ? "#{host}:#{port}" : host
  end
end
