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
      { project: project, rank: ranker.calculate_rank }
    end

    # Sort projects by rank in descending order
    ranked_projects.sort_by! { |project| -project[:rank] }

    # Return the ranked projects
    ranked_projects
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
    <li>
      <%= link_to project[:project].name, project_path(project[:project]) %>
      (Rank: <%= project[:rank].round(2) %>)
    </li>
  <% end %>
</ul>
```

```javascript
// app/assets/javascripts/components/ProjectForm.js (updated)
import React, { useState } from 'react';
import { Link } from 'react-router-dom';

const ProjectForm = () => {
  const [project, setProject] = useState({});

  const handleSubmit = (event) => {
    event.preventDefault();

    // Create a new project
    const newProject = { ...project };

    // Calculate the project's rank
    const ranker = new ProjectRanker(newProject);
    const rank = ranker.calculate_rank();

    // Display the project's rank
    console.log(`Project rank: ${rank}`);
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* ... */}
    </form>
  );
};

export default ProjectForm;
```

```ruby
# spec/services/project_ranker_spec.rb (new)
require 'rails_helper'

RSpec.describe ProjectRanker do
  let(:project) { create(:project) }

  describe '#calculate_rank' do
    it 'calculates the project rank based on reviews, discussions, and submissions' do
      # Create reviews, discussions, and submissions for the project
      create_list(:review, 5, project: project)
      create_list(:discussion, 3, project: project)
      create_list(:submission, 2, project: project)

      # Calculate the project rank
      ranker = ProjectRanker.new(project)
      rank = ranker.calculate_rank

      # Expect the rank to be within the expected range
      expect(rank).to be_within(1).of(50)
    end
  end

  describe '.rank_projects' do
    it 'ranks projects based on their calculated ranks' do
      # Create multiple projects with different numbers of reviews, discussions, and submissions
      projects = create_list(:project, 5)

      # Calculate the ranks for each project
      ranked_projects = ProjectRanker.rank_projects(projects)

      # Expect the projects to be ranked in descending order of their ranks
      expect(ranked_projects.map { |project| project[:rank] }).to eq(ranked_projects.map { |project| project[:rank] }.sort.reverse)
    end
  end
end