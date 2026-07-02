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

    # Normalize rank to a value between 0 and 100
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
  def index
    @projects = Project.all
    @ranked_projects = ProjectRanker.rank_projects(@projects)
  end
end
```

```ruby
# app/views/projects/index.html.erb (updated)
<h1>Projects</h1>

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
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function ProjectForm() {
  const [projects, setProjects] = useState([]);
  const [rankedProjects, setRankedProjects] = useState([]);

  useEffect(() => {
    axios.get('/projects')
      .then(response => {
        setProjects(response.data);
        setRankedProjects(response.data.map(project => ({ project, rank: project.rank })));
      })
      .catch(error => {
        console.error(error);
      });
  }, []);

  return (
    <div>
      <h1>Projects</h1>
      <ul>
        {rankedProjects.map(project => (
          <li key={project.project.id}>
            <a href={`/projects/${project.project.id}`}>{project.project.name}</a>
            (Rank: {project.rank})
          </li>
        ))}
      </ul>
    </div>
  );
}

export default ProjectForm;