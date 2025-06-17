# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
    @comments = @project.comments
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects or /projects.json
  def create
    service = Projects::Create.new(project_params)
    service.call

    respond_to do |format|
      if service.errors.blank?
        format.html { redirect_to service.project, notice: 'Project was successfully created.' }
      else
        format.html do
          render :new, status: :unprocessable_entity, assigns: { project: service.project,
                                                                 status_change_record: service.status_change_record }
        end
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    service = Projects::Update.new(@project, project_params)
    service.call

    respond_to do |format|
      if service.errors.blank?
        format.html { redirect_to service.project, notice: 'Project was successfully updated.' }
      else
        format.html do
          render :edit, status: :unprocessable_entity, assigns: { project: service.project,
                                                                  status_change_record: service.status_change_record }
        end
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :status, :description)
  end
end
