require 'spec_helper'
require_relative '../../services/recommendation_sorter_service'

describe Services::RecommendationSorterService do
  describe '#call' do
    let(:recommendations) { []}
    subject do
      service = described_class.new(recommendations: recommendations)
      service.call
      service
    end

    it 'sorts recommendations successfully' do
      recommendations.replace([
        { jobseeker_id: 1, matching_skill_percent: 50, job_id: 2 },
        { jobseeker_id: 1, matching_skill_percent: 50, job_id: 7 },
        { jobseeker_id: 1, matching_skill_percent: 100, job_id: 5 }
      ])

      expect(subject.sorted_recommendations).to eq([
        { jobseeker_id: 1, matching_skill_percent: 100, job_id: 5 },
        { jobseeker_id: 1, matching_skill_percent: 50, job_id: 2 },
        { jobseeker_id: 1, matching_skill_percent: 50, job_id: 7 }
      ])
    end

    it 'handles sorting errors' do
      recommendations.replace([
        { jd: 1, mi: 'invalid', ji: 2 }
      ])

      expect(subject.errors).to include(/Error while sorting/)
    end
  end
end
