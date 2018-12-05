# Adds the `byte_size` methods to the Disk and S3 services for Active Storage.
# Adds the `download_part` method for range queries and streaming.

module AddStreamingMethodsToService
  module Base

    # @return [Integer] The size of the blob, in bytes.

    def byte_size
      raise NotImplementedError
    end

    # @overload download_part(key, range)
    #   Returns the range of the data stored at the given location.
    #   @param [String] key The location key of the blob within the service.
    #   @param [Range<Integer>] range The range of data to download.
    #   @return [String] The portion of the data.
    # @overload download_part(key, range)
    #   Streams the range of the data stored at the given location.
    #   @param [String] key The location key of the blob within the service.
    #   @param [Range<Integer>] range The range of data to download.
    #   @yield (chunk) A block of code to run for each chunk of streamed data.
    #   @yieldparam [String] chunk A sequential chunk of data. Guaranteed not to
    #     extend before the start of, or after the end of, the given range.

    def download_part(key, range)
      raise NotImplementedError
    end
  end

  module S3
    def byte_size(key)
      object_for(key).content_length
    end

    def download_part(key, range)
      range  = range.first..object.content_length if range.last == -1
      buffer = String.new

      instrument :streaming_download, key: key do
        object = object_for(key)

        chunk_size = 5.megabytes
        offset     = range.first

        while offset < range.last
          this_chunk_end = (offset + chunk_size >= range.last) ? range.last : offset + chunk_size - 1
          chunk          = object.get(range: "bytes=#{offset}-#{this_chunk_end}").body.read.force_encoding(Encoding::BINARY)
          block_given? ? yield(chunk) : buffer << chunk
          offset += chunk_size
        end
      end

      return buffer unless block_given?
    end
  end

  module Disk
    def byte_size(key)
      File.stat(path_for(key)).size
    end

    def download_part(key, range)
      range  = range.first..byte_size(key) if range.last == -1
      buffer = String.new

      instrument :streaming_download, key: key do
        chunk_size = 1.megabyte
        offset     = range.first

        File.open(path_for(key), 'rb') do |file|
          file.seek(range.first)
          while offset < range.last
            this_chunk_size = (offset + chunk_size >= range.last) ? (range.last - offset + 1) : chunk_size
            chunk           = file.read(this_chunk_size).force_encoding(Encoding::BINARY)
            block_given? ? yield(chunk) : buffer << chunk
            offset += chunk.bytesize
          end
        end
      end

      return buffer unless block_given?
    end
  end
end

# Adds support for range queries to `ActiveStorage::DiskController` for
# streaming.

module AddRangeQueriesToDiskController

  # Reimplements the `show` action (which streams files from disk) to support
  # `Range` headers in the request, and supply `Content-Length`/`Content-Range`
  # headers in the response along with a ranged subset of the data.
  #
  # Currently only one single range, expressed in bytes, is supported.

  def show
    if (key = decode_verified_key)
      response.headers['Accept-Ranges'] = 'bytes'

      if (ranges = parse_ranges(request.headers['Range']))
        units, (range, *rest) = ranges
        raise BadRangeError if units != 'bytes' || rest.any?

        size = disk_service.byte_size(key)
        raise BadRangeError if range.first < 0 || range.last > size

        data = disk_service.download_part(key, range)

        response.headers['Content-Length'] = data.bytesize.to_s
        response.headers['Content-Range'] = "bytes #{range.first}-#{range.last == -1 ? size : range.last}/#{size}"
        response.status = :partial_content unless data.bytesize == size

        if request.head?
          response.body = ''
        else
          send_data data,
                    disposition:  params[:disposition],
                    content_type: params[:content_type]
        end
      else
        size = disk_service.byte_size(key)
        response.headers['Content-Length'] = size.to_s

        send_data disk_service.download(key),
                  disposition:  params[:disposition],
                  content_type: params[:content_type]
      end
    else
      head :not_found
    end
  rescue BadRangeError
    head :range_not_satisfiable
  end

  private

  RANGE_ELEMENT       = /\d+-\d*/
  RANGE_ELEMENT_PARSE = /(\d+)-(\d*)/
  RANGE_HEADER        = /^(\w+)=((?:#{RANGE_ELEMENT},\s*)*#{RANGE_ELEMENT})$/
  private_constant :RANGE_ELEMENT, :RANGE_ELEMENT_PARSE, :RANGE_HEADER

  def parse_ranges(header)
    return nil if header.blank?
    matches = header.match(RANGE_HEADER) or raise BadRangeError
    unit   = matches[1]
    ranges = matches[2]
    return unit, parse_range_elements(ranges)
  end

  def parse_range_elements(string)
    string.split(/,\s*/).map do |part|
      matches = part.match(RANGE_ELEMENT_PARSE) or raise BadRangeError
      (matches[1].to_i)..(matches[2].presence&.to_i || -1)
    end
  end

  # @private
  class BadRangeError < StandardError; end
end

Rails.application.config.to_prepare do
  require 'active_storage/service/disk_service'
  require 'active_storage/service/s3_service'

  ActiveStorage::Service.prepend AddStreamingMethodsToService::Base
  ActiveStorage::Service::DiskService.prepend AddStreamingMethodsToService::Disk
  ActiveStorage::Service::S3Service.prepend AddStreamingMethodsToService::S3

  ActiveStorage::DiskController.prepend AddRangeQueriesToDiskController
end