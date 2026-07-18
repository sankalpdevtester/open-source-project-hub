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
    normalized_rank = (rank / (reviews + discussions + submissions).to_f) * 100

    # Return the normalized rank
    normalized_rank
  end

  def self.rank_projects(projects)
    # Rank projects based on their calculated ranks
    ranked_projects = projects.map do |project|
      ranker = ProjectRanker.new(project)
      [project, ranker.calculate_rank]
    end

    # Sort projects by rank in descending order
    ranked_projects.sort_by! { |_, rank| -rank }

    # Return the sorted projects
    ranked_projects.map { |project, _| project }
  end
end
```

```ruby
# app/controllers/projects_controller.rb (updated)
class ProjectsController < ApplicationController
  # ...

  def index
    @projects = Project.all
    @ranked_projects = ProjectRanker.rank_projects(@projects)
  end

  # ...
end
```

```ruby
# app/views/projects/index.html.erb (updated)
<h1>Projects</h1>

<h2>Ranked Projects</h2>
<ul>
  <% @ranked_projects.each do |project| %>
    <li><%= link_to project.name, project_path(project) %></li>
  <% end %>
</ul>

<h2>All Projects</h2>
<ul>
  <% @projects.each do |project| %>
    <li><%= link_to project.name, project_path(project) %></li>
  <% end %>
</ul>
```

```ruby
# spec/services/project_ranker_spec.rb (new)
require 'rails_helper'

RSpec.describe ProjectRanker do
  let(:project) { create(:project) }
  let(:review) { create(:review, project: project) }
  let(:discussion) { create(:discussion, project: project) }
  let(:submission) { create(:submission, project: project) }

  describe '#calculate_rank' do
    it 'calculates the rank based on reviews, discussions, and submissions' do
      expect(ProjectRanker.new(project).calculate_rank).to be > 0
    end

    it 'assigns weights to each factor' do
      expect(ProjectRanker.new(project).instance_variable_get(:@review_weight)).to eq 0.4
      expect(ProjectRanker.new(project).instance_variable_get(:@discussion_weight)).to eq 0.3
      expect(ProjectRanker.new(project).instance_variable_get(:@submission_weight)).to eq 0.3
    end
  end

  describe '#rank_projects' do
    it 'ranks projects based on their calculated ranks' do
      projects = [project, create(:project)]
      ranked_projects = ProjectRanker.rank_projects(projects)
      expect(ranked_projects.first).to eq project
    end
  end
end