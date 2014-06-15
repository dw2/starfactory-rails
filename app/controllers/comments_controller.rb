class CommentsController < ApplicationController
  respond_to :html

  before_action :load_comment, only: [:update, :destroy]
  before_action :load_discussion
  before_action :load_workshop

  def edit
    add_breadcrumb @comment.workshop_name, workshop_url(@comment.workshop)
    add_breadcrumb 'Comments', workshop_comments_url(@comment.workshop)
    add_breadcrumb @comment.name, comment_url(@comment)
    add_breadcrumb 'Edit'
    authorize @comment
    respond_with @comment
  end

  def create
    @comment = policy_scope(Comment).new(comment_params)
    authorize @comment
    @comment.save
    respond_with @comment,
      location: workshop_discussion_url(workshop_id: @workshop, id: @discussion),
      error: 'Unable to create comment.'
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = 'Comment has been updated.'
    end
    respond_with @comment,
      location: workshop_discussion_url(workshop_id: @workshop, id: @discussion),
      error: 'Unable to update comment.'
  end

  def destroy
    @comment.destroy
    respond_with @comment,
      location: workshop_discussion_url(workshop_id: @workshop, id: @discussion),
      error: 'Unable to remove comment.'
  end

private
  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_discussion
    @discussion = Discussion.find(params[:discussion_id])
  end

  def load_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end

  def comment_params
    params.require(:comment).permit(
      *policy(@comment || Comment).permitted_attributes
    )
  end
end