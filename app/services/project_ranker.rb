# app/services/project_ranker.rb

class ProjectRanker
  def initialize
    @projects = Project.all
  end

  def rank_projects
    @projects.sort_by { |project| calculate_project_score(project) }.reverse
  end

  private

  def calculate_project_score(project)
    score = 0
    score += project.reviews.count * 5
    score += project.discussions.count * 3
    score += project.stars.count * 2
    score
  end

  def get_project_reviews(project)
    project.reviews
  end

  def get_project_discussions(project)
    project.discussions
  end

  def get_project_stars(project)
    project.stars
  end
end

class ProjectRankerHelper
  def self.get_top_projects(limit = 10)
    project_ranker = ProjectRanker.new
    project_ranker.rank_projects[0...limit]
  end
end
```

# Usage example in a controller
```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def index
    @top_projects = ProjectRankerHelper.get_top_projects
  end
end
```

# Usage example in a view
```erb
<!-- app/views/projects/index.html.erb -->
<h1>Top Projects</h1>
<ul>
  <% @top_projects.each do |project| %>
    <li><%= link_to project.name, project_path(project) %></li>
  <% end %>
</ul>
```

# Integration with existing files
The `ProjectRanker` service uses the `Project` model to retrieve project data and calculate the project score. The `ProjectRankerHelper` class provides a convenient method to get the top projects, which can be used in controllers and views. The `project_helper.rb` file can be updated to include a method that uses the `ProjectRankerHelper` class.

```ruby
# app/helpers/project_helper.rb
module ProjectHelper
  def get_top_projects
    ProjectRankerHelper.get_top_projects
  end
end
```

# Database schema update
No changes are required to the database schema, as the `ProjectRanker` service uses existing associations and columns.

# Test cases
Test cases can be added to ensure the `ProjectRanker` service is working correctly.

```ruby
# spec/services/project_ranker_spec.rb
require 'rails_helper'

RSpec.describe ProjectRanker do
  let(:project) { create(:project) }
  let(:review) { create(:review, project: project) }
  let(:discussion) { create(:discussion, project: project) }
  let(:star) { create(:star, project: project) }

  it 'calculates the project score correctly' do
    expect(ProjectRanker.new.calculate_project_score(project)).to eq(0)
    review
    expect(ProjectRanker.new.calculate_project_score(project)).to eq(5)
    discussion
    expect(ProjectRanker.new.calculate_project_score(project)).to eq(8)
    star
    expect(ProjectRanker.new.calculate_project_score(project)).to eq(10)
  end

  it 'ranks projects correctly' do
    project1 = create(:project)
    project2 = create(:project)
    create(:review, project: project1)
    create(:discussion, project: project2)
    expect(ProjectRanker.new.rank_projects).to eq([project1, project2])
  end
end