require 'csv'

module Helpers
  class CSVReader
    def self.read_jobseekers(file_path)
      CSV.read(file_path, headers: true).map do |row|
        JobSeeker.new(row['id'].to_i, row['name'], row['skills'].split(',').map(&:strip))
      end
    end
  
    def self.read_jobs(file_path)
      CSV.read(file_path, headers: true).map do |row|
        Job.new(row['id'].to_i, row['title'], row['required_skills'].split(',').map(&:strip))
      end
    end
  end
end
