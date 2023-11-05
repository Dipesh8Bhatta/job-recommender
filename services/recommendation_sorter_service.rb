require_relative 'base_service'

module Services
  class RecommendationSorterService < BaseService
    attr_reader :recommendations
    attr_reader :sorted_recommendations

    def initialize(**kwargs)
      super
      @recommendations = kwargs[:recommendations]
    end

    def call
      sort_recommendations

      successful?
    end

    private

    def sort_recommendations
      @sorted_recommendations = @recommendations.sort_by do |rec|
        [rec[:jobseeker_id], -rec[:matching_skill_percent], rec[:job_id]]
      end
    rescue StandardError => e
      add_error("Error while sorting: #{e.inspect}")
    end
  end
end
