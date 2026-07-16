# app/services/project_ranker.rb

class ProjectRanker
  def initialize(project)
    @project = project
  end

  def calculate_score
    # Calculate the project score based on the number of stars, forks, and reviews
    score = (@project.stars * 2) + (@project.forks * 1.5) + (@project.reviews.count * 1)
    score
  end

  def rank_project
    # Rank the project based on its score
    Project.order(score: :desc).find_index(@project) + 1
  end

  def update_project_score
    # Update the project score and rank
    @project.score = calculate_score
    @project.rank = rank_project
    @project.save
  end

  def self.update_all_project_scores
    # Update the scores and ranks of all projects
    Project.all.each do |project|
      ranker = ProjectRanker.new(project)
      ranker.update_project_score
    end
  end
end
```

```ruby
# app/controllers/projects_controller.rb (updated)
class ProjectsController < ApplicationController
  # ...

  def create
    # ...
    @project = Project.new(project_params)
    if @project.save
      # Update the project score and rank
      ProjectRanker.new(@project).update_project_score
      # ...
    end
  end

  def update
    # ...
    if @project.update(project_params)
      # Update the project score and rank
      ProjectRanker.new(@project).update_project_score
      # ...
    end
  end
end
```

```ruby
# db/models/project.rb (updated)
class Project < ApplicationRecord
  # ...

  def score
    # Calculate the project score based on the number of stars, forks, and reviews
    (self.stars * 2) + (self.forks * 1.5) + (self.reviews.count * 1)
  end

  def rank
    # Rank the project based on its score
    Project.order(score: :desc).find_index(self) + 1
  end
end
```

```ruby
# spec/services/project_ranker_spec.rb (new)
require 'rails_helper'

RSpec.describe ProjectRanker do
  let(:project) { create(:project) }

  describe '#calculate_score' do
    it 'calculates the project score based on the number of stars, forks, and reviews' do
      project.stars = 10
      project.forks = 5
      project.reviews = create_list(:review, 3)
      expect(ProjectRanker.new(project).calculate_score).to eq(10 * 2 + 5 * 1.5 + 3 * 1)
    end
  end

  describe '#rank_project' do
    it 'ranks the project based on its score' do
      project.stars = 10
      project.forks = 5
      project.reviews = create_list(:review, 3)
      expect(ProjectRanker.new(project).rank_project).to eq(1)
    end
  end

  describe '#update_project_score' do
    it 'updates the project score and rank' do
      project.stars = 10
      project.forks = 5
      project.reviews = create_list(:review, 3)
      ProjectRanker.new(project).update_project_score
      expect(project.score).to eq(10 * 2 + 5 * 1.5 + 3 * 1)
      expect(project.rank).to eq(1)
    end
  end
end