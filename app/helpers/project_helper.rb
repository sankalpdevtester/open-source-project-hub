# app/helpers/project_helper.rb

module ProjectHelper
  # Existing code...

  # Calculate project popularity score based on number of stars, forks, and reviews
  def calculate_popularity_score(project)
    stars = project.stars_count
    forks = project.forks_count
    reviews = project.reviews_count

    # Assign weights to each factor
    star_weight = 0.5
    fork_weight = 0.3
    review_weight = 0.2

    # Calculate popularity score
    popularity_score = (star_weight * stars) + (fork_weight * forks) + (review_weight * reviews)

    # Normalize score to a range of 0-100
    normalized_score = (popularity_score / (star_weight + fork_weight + review_weight)) * 100

    normalized_score
  end
end