# app/helpers/project_helper.rb

module ProjectHelper
  # Existing code...

  # Calculate project popularity score based on the number of stars, forks, and watchers
  def calculate_popularity_score(project)
    stars = project.stars_count
    forks = project.forks_count
    watchers = project.watchers_count

    # Assign weights to each factor
    stars_weight = 0.5
    forks_weight = 0.3
    watchers_weight = 0.2

    # Calculate the popularity score
    popularity_score = (stars * stars_weight) + (forks * forks_weight) + (watchers * watchers_weight)

    # Return the popularity score
    popularity_score
  end
end