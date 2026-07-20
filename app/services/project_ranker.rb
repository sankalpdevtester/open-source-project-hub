# app/services/project_ranker.rb

class ProjectRanker
  def initialize(project)
    @project = project
  end

  def calculate_rank
    # Calculate rank based on project's reviews, discussions, and submissions
    reviews = @project.reviews.count
    discussions = @project.discussions.count
    submissions = @project.submissions.count

    # Assign weights to each factor
    review_weight = 0.4
    discussion_weight = 0.3
    submission_weight = 0.3

    # Calculate rank
    rank = (reviews * review_weight) + (discussions * discussion_weight) + (submissions * submission_weight)

    # Normalize rank to a scale of 1-100
    normalized_rank = (rank / (reviews + discussions + submissions).to_f) * 100 if (reviews + discussions + submissions) > 0

    # Return the normalized rank
    normalized_rank || 0
  end

  def self.rank_projects(projects)
    # Rank projects based on their calculated ranks
    projects.sort_by { |project| ProjectRanker.new(project).calculate_rank }.reverse
  end
end

# Example usage:
# projects = Project.all
# ranked_projects = ProjectRanker.rank_projects(projects)
# ranked_projects.each do |project|
#   puts "Project: #{project.name}, Rank: #{ProjectRanker.new(project).calculate_rank}"
# end
```

# Integration with existing files:
# - `app/controllers/projects_controller.rb`: Use the `ProjectRanker` service to calculate project ranks and display them in the project index view.
# - `app/views/projects/index.html.erb`: Display the project ranks in the project index view.
# - `app/helpers/project_helper.rb`: Use the `ProjectRanker` service to calculate project ranks and display them in the project show view.
# - `spec/requests/projects_request_spec.rb`: Test the project ranking API endpoint.
# - `spec/factories/projects.rb`: Create test projects with varying numbers of reviews, discussions, and submissions to test the ranking algorithm.

# Usage in `projects_controller.rb`:
```ruby
# app/controllers/projects_controller.rb

class ProjectsController < ApplicationController
  def index
    @projects = ProjectRanker.rank_projects(Project.all)
  end
end
```

# Usage in `project_helper.rb`:
```ruby
# app/helpers/project_helper.rb

module ProjectHelper
  def project_rank(project)
    ProjectRanker.new(project).calculate_rank
  end
end
```

# Usage in `index.html.erb`:
```erb
<!-- app/views/projects/index.html.erb -->

<h1>Projects</h1>

<ul>
  <% @projects.each do |project| %>
    <li>
      <%= link_to project.name, project %>
      (Rank: <%= project_rank(project) %>)
    </li>
  <% end %>
</ul>