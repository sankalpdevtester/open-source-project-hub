# frozen_string_literal: true

module ProjectHelper
  # ... existing code ...

  def self.calculate_popularity_score(project)
    # Calculate popularity score based on project's watch count, star count, and fork count
    watch_count = project.watchers.count
    star_count = project.stars.count
    fork_count = project.forks.count

    # Assign weights to each factor
    watch_weight = 0.3
    star_weight = 0.4
    fork_weight = 0.3

    # Calculate popularity score
    popularity_score = (watch_count * watch_weight) + (star_count * star_weight) + (fork_count * fork_weight)

    # Normalize popularity score to a value between 0 and 100
    max_score = 100
    min_score = 0
    normalized_score = ((popularity_score - min_score) / (max_score - min_score)) * 100

    normalized_score
  end
end