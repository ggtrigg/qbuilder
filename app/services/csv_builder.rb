require "csv"

class CsvBuilder
  def self.build(rows, headers = nil)
    CSV.generate do |csv|
      csv << headers if headers
      rows.each do |row|
        csv << row
      end
    end
  end
end
