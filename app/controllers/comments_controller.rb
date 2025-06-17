# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_project, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @project.comments.new(comment_params)

    if @comment.save
      redirect_to project_path(@project), notice: 'Comment was successfully created.'
    else
      errors = "Error while saving comment: #{@comment.errors.map(&:full_message).join(', ')}"
      redirect_to project_path(@project), alert: errors
    end
  end

  def destroy
    @comment.destroy

    redirect_to project_path(@project), notice: 'Comment was successfully destroyed.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comment
    @comment = @project.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:user_name, :body)
  end
end
