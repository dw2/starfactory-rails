class InstructorProfilesController < ApplicationController
  respond_to :html

  before_action :load_instructor_profile, only: [:show, :edit, :update, :destroy]

  add_breadcrumb 'Instructors', :instructor_profiles_url

  # GET /instructors
  def index
    @instructor_profiles = InstructorProfile.by_name.page params[:page]
    authorize @instructor_profiles
    respond_with @instructor_profiles
  end

  # GET /instructors/1
  def show
    add_breadcrumb @instructor_profile.name
    authorize @instructor_profile
    respond_with @instructor_profile
  end

  # GET /instructors/new
  def new
    @instructor_profile = policy_scope(InstructorProfile).new
    @instructor_profile.user_id = params[:user].to_i
    add_breadcrumb 'New'
    authorize @instructor_profile
    respond_with @instructor_profile
  end

  # GET /instructors/1/edit
  def edit
    add_breadcrumb @instructor_profile.name, instructor_profile_url(@instructor_profile)
    add_breadcrumb 'Edit'
    authorize @instructor_profile
    respond_with @instructor_profile
  end

  # POST /instructors
  def create
    @instructor_profile = policy_scope(InstructorProfile).new(instructor_profile_params)
    authorize @instructor_profile
    if @instructor_profile.save
      flash[:notice] = "Instructor #{@instructor_profile.name} has been added."
    end
    respond_with @instructor_profile, location: admin_instructors_url, error: 'Unable to add instructor.'
  end

  # PATCH/PUT /instructors/1
  def update
    @instructor_profile.update(instructor_profile_params)
    respond_with @instructor_profile, location: @instructor_profile, error: 'Unable to save instructor.'
  end

  # DELETE /instructors/1
  def destroy
    @instructor_profile.destroy
    respond_with @instructor_profile, location: @instructor_profile, error: 'Unable to remove instructor.'
  end

private
  def load_instructor_profile
    @instructor_profile = policy_scope(InstructorProfile).find(params[:id])
  end

  def instructor_profile_params
    params.require(:instructor_profile).permit(
      *policy(@instructor_profile || InstructorProfile).permitted_attributes
    )
  end
end
