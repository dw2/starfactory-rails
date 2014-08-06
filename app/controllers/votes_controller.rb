class VotesController < ApplicationController
  respond_to :html

  def create
    object = get_parent_object
    @resource = get_parent_resource object
    if current_user && object
      @vote = Vote.new(
        user_id: current_user.id,
        :"#{object}_id" => params[:"#{object}_id"]
      )
      begin
        if @vote.save
          flash[:notice] = "We got your vote. You'll be notified when the class gets scheduled."
        end
      rescue ActiveRecord::RecordNotUnique
        flash[:notice] = 'You already voted for this.'
      end
      respond_with @vote, location: @resource
    else
      redirect_to polymorphic_url(@resource, register_and_vote: true)
    end
  end

  def destroy
    @vote = Vote.find params[:id]
    @vote.destroy
    @resource = get_parent_resource
    respond_with @vote, location: @resource, error: 'Unable to remove vote.'
  end

private
  def get_parent_object
    parent_objects = %w(workshop)
    parent_objects.detect { |r| params[:"#{r}_id"].present? }
  end

  def get_parent_resource(object = nil)
    object = get_parent_object if !object
    !object ? nil : object.camelize.constantize.find(params[:"#{object}_id"])
  end
end
