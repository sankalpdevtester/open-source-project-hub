require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'GET /projects' do
    it 'returns a list of projects' do
      project = create(:project)
      get projects_path
      expect(response).to be_successful
      expect(response.body).to include(project.name)
    end
  end

  describe 'POST /projects' do
    it 'creates a new project' do
      project_params = { project: { name: 'New Project', description: 'This is a new project', url: 'https://example.com' } }
      expect { post projects_path, params: project_params }.to change(Project, :count).by(1)
      expect(response).to be_successful
    end

    it 'returns an error if the project is invalid' do
      project_params = { project: { name: '', description: '', url: '' } }
      post projects_path, params: project_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end