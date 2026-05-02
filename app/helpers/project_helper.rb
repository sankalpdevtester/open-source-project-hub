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

    # Return the popularity score
    popularity_score
  end
end