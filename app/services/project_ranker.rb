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

# Example usage in a controller
```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def index
    @top_projects = ProjectRankerHelper.get_top_projects
    render json: @top_projects
  end
end
```

# Example usage in a React component
```jsx
// components/ProjectList.js
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function ProjectList() {
  const [projects, setProjects] = useState([]);

  useEffect(() => {
    axios.get('/projects')
      .then(response => {
        setProjects(response.data);
      })
      .catch(error => {
        console.error(error);
      });
  }, []);

  return (
    <div>
      <h1>Top Projects</h1>
      <ul>
        {projects.map(project => (
          <li key={project.id}>{project.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default ProjectList;