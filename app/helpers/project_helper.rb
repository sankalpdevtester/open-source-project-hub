# app/helpers/project_helper.rb

module ProjectHelper
  # Existing code...

  # Calculate project popularity score based on number of reviews and watchers
  def calculate_popularity_score(project)
    reviews = project.reviews.count
    watchers = project.watchers.count
    score = (reviews * 0.6) + (watchers * 0.4)
    score.round(2)
  end
end