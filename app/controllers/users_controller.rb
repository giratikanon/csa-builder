class UsersController < ApplicationController

  def create

    project = Project.create(params[:project])
    if project.valid?
      respond_with(project, :location => api_v1_project_path(project))
    else
      respond_with(project)
    end
  end

end

