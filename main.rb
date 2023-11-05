require_relative 'services/recommendation_service'
require_relative 'services/recommendation_sorter_service'
require_relative 'helpers/csv_reader'
require_relative 'helpers/csv_writer'

puts 'Start'
# Instead of creating classes and using it to store the each csv row data in structure,
# use struct class provided by ruby
Job = Struct.new(:id, :title, :required_skills)
JobSeeker = Struct.new(:id, :name, :skills)

# Read jobseekers and jobs
puts 'Starts reading csv files......'
jobs = Helpers::CSVReader.read_jobs('jobs.csv')
jobseekers = Helpers::CSVReader.read_jobseekers('jobseekers.csv')
puts 'Completes reading csv files.'

# Generate job recommendations
puts 'Starts Recommendation Service......'
recommendations_service = Services::RecommendationService.new(jobseekers: jobseekers, jobs: jobs)
if recommendations_service.call
  puts 'Completes Recommendation Service.'
  recommendations = recommendations_service.recommendations
else
  recommendations_service.log_error
  return
end

# sort recommendations
puts 'Starts sorting Recommendation......'
sorted_recommendations_service = Services::RecommendationSorterService.new(recommendations: recommendations)
if sorted_recommendations_service.call
  puts 'Completes Sorting Recommendations.'
  sorted_recommendations = sorted_recommendations_service.sorted_recommendations
else
  sorted_recommendations_service.log_error
  return
end

# Write output to file
Helpers::CSVWriter.write_recommendations(sorted_recommendations, 'job_recommendations.csv')
puts 'Output written to job_recommendations.csv......'
puts 'End'
