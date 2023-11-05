require_relative 'base_service'

module Services
  class RecommendationService < BaseService
    attr_reader :recommendations
    attr_reader :jobseekers
    attr_reader :jobs

    def initialize(**kwargs)
      super
      @recommendations = []
      @jobseekers = kwargs[:jobseekers]
      @jobs = kwargs[:jobs]
    end

    def call
      generate_recommendations

      successful?
    end

    private

    def generate_recommendations
      @jobseekers.each do |jobseeker|
        @jobs.each do |job|
          matching_skills = jobseeker.skills & job.required_skills
          matching_skill_count = matching_skills.size
          next if matching_skill_count.zero?

          begin
            matching_skill_percent = calculation_matching_percent(matching_skill_count, job.required_skills.size)
          rescue
            add_error("Percentage calculation error for job seeker id: #{jobseeker.id} and job: #{job.id}")
            return
          end
  
          @recommendations << {
            jobseeker_id: jobseeker.id,
            jobseeker_name: jobseeker.name,
            job_id: job.id,
            job_title: job.title,
            matching_skill_count: matching_skill_count,
            matching_skill_percent: matching_skill_percent
          }
        end
      end
    end

    def calculation_matching_percent(matching_skills_count, total_required_skills)
      (matching_skills_count.to_f / total_required_skills * 100).round(2)
    end
  end
end
