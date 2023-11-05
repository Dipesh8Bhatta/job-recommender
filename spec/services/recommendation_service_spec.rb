require 'spec_helper'
require_relative '../../services/recommendation_service'

describe Services::RecommendationService do
  let(:jobseeker1) { double(id: 1, name: 'Dipesh', skills: ['Ruby', 'Rails', 'Java', 'Python']) }
  let(:jobseeker2) { double(id: 2, name: 'Some Random Guy', skills: ['Java', 'C']) }

  let(:job1) { double(id: 1, title: 'Ruby Developer', required_skills: ['Ruby', 'Rails']) }
  let(:job2) { double(id: 2, title: 'Java Developer', required_skills: ['Java', 'Spring', 'Turbine']) }

  let(:jobseekers) { [jobseeker1, jobseeker2] }
  let(:jobs) { [job1, job2] }

  describe '#call' do
    subject do
      service = described_class.new(jobseekers: jobseekers, jobs: jobs)
      service.call
      service
    end

    it 'generates recommendations successfully' do
      expect(subject.recommendations.size).to eq(3) # There are 3 possible combinations
      expect(subject.recommendations).to include(
        jobseeker_id: 1, jobseeker_name: 'Dipesh', job_id: 1, job_title: 'Ruby Developer',
        matching_skill_count: 2, matching_skill_percent: 100.0
      )
    end

    it 'handles percentage calculation errors' do
      allow_any_instance_of(described_class).to receive(:calculation_matching_percent).and_raise(ZeroDivisionError)
      expect(subject.errors).to include(/Percentage calculation error for job seeker id: 1 and job: 1/)
    end
  end
end
