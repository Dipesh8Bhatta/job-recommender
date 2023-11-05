require 'csv'

module Helpers
  class CSVWriter
    def self.write_recommendations(recommendations, file_path)
      CSV.open(file_path, 'w') do |csv|
        csv << ['jobseeker_id', 'jobseeker_name', 'job_id', 'job_title', 'matching_skill_count', 'matching_skill_percent']
        recommendations.each do |rec|
          csv << [rec[:jobseeker_id], rec[:jobseeker_name], rec[:job_id], rec[:job_title], rec[:matching_skill_count], rec[:matching_skill_percent]]
        end
      end
    end
  end
end
