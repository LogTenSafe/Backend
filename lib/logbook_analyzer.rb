# Loads LogTen Pro logbooks using SQLite, and performs queries to produce
# metadata about the logbook, which is saved to the Blob's `metadata` field.

class LogbookAnalyzer < ActiveStorage::Analyzer
  # @private
  def self.accept?(blob)
    blob.content_type == 'application/x-sqlite3' ||
        blob.content_type == 'application/vnd.sqlite3' ||
        blob.content_type == 'application/sql'
  end

  # @private
  def metadata
    {
        total_hours:,
        last_flight: ({
            date:        flight_date(last_flight),
            origin:      flight_origin(last_flight),
            destination: flight_destination(last_flight),
            duration:    flight_duration(last_flight)
        } if last_flight)
    }
  end

  private

  def db
    @db ||= download_blob_to_tempfile { |file| SQLite3::Database.new(file.path) }
  end

  def total_hours
    return 0 unless last_flight

    # unfortunately, to calculate total hours we can't simply do a SUM() query.
    # total time is not the sum of the # of minutes of all flights; instead, each
    # time is rounded to the 1/10th of an hour, and those values are summed.
    # sqlite rounds, e.g. 0.85 down to 0.8, not up to 0.9, due to the way it
    # stores floats internally. this is different than the way the LogTen
    # application does fractional math, resulting in compounding discrepancies
    # in time calculations. to solve this, we instead take the numbers into
    # ruby-land, and sum them there, where the result is equal to the one logten
    # gives.
    times = db.execute('SELECT ZFLIGHT_TOTALTIME FROM ZFLIGHT').flatten
    times.compact.sum { |t| (t / 60.0).round(1) }
  end

  def last_flight
    @last_flight ||= begin
      columns, last_flight = db.execute2('SELECT * FROM ZFLIGHT ORDER BY ZFLIGHT_FLIGHTDATE DESC LIMIT 1').first(2)
      last_flight.nil? ? nil : Hash[*columns.zip(last_flight).flatten]
    end
  end

  def flight_date(flight)
    return nil unless flight

    Time.utc(2001).advance(seconds: flight['ZFLIGHT_FLIGHTDATE']).utc.to_date
  end

  def flight_origin(flight)
    db.get_first_value('SELECT ZPLACE_FAAID FROM ZPLACE WHERE Z_PK = ?', flight['ZFLIGHT_FROMPLACE'])
  end

  def flight_destination(flight)
    db.get_first_value('SELECT ZPLACE_FAAID FROM ZPLACE WHERE Z_PK = ?', flight['ZFLIGHT_TOPLACE'])
  end

  def flight_duration(flight)
    (flight['ZFLIGHT_TOTALTIME'] / 60.0).round(1)
  end
end
