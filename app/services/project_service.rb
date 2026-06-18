class ProjectService
  def self.search_projects(query)
    Project.where("name ILIKE :query OR description ILIKE :query", query: "%#{query}%")
  end

  def self.get_project_showcase(project_id)
    project = Project.find(project_id)
    {
      id: project.id,
      name: project.name,
      description: project.description,
      url: project.url,
      user: {
        id: project.user.id,
        name: project.user.name
      }
    }
  end

  def self.create_project(project_params)
    project = Project.new(project_params)
    project.user = current_user
    project.save
    project
  end

  def self.update_project(project_id, project_params)
    project = Project.find(project_id)
    project.update(project_params)
    project
  end

  def self.destroy_project(project_id)
    project = Project.find(project_id)
    project.destroy
  end
end