class CouponsController < ApplicationController
  respond_to :html, :js

  before_action :load_coupon, only: [:edit, :update, :destroy]

  add_breadcrumb 'Coupons', :admin_coupons_url

  # GET /coupons/check
  def check
    if @coupon = Coupon.find_by(
      code: coupon_params[:code],
      event_id: coupon_params[:event_id])

      authorize @coupon
      render json: {
        success: true,
        coupon: @coupon.slice(:code, :amount_in_cents, :formatted_amount)
      }
    else
      render json: { success: false }
    end
  end

  # GET /coupons/new
  def new
    @coupon = policy_scope(Coupon).new
    add_breadcrumb 'New'
    authorize @coupon
    respond_with @coupon
  end

  # GET /coupons/1/edit
  def edit
    add_breadcrumb @coupon.code, coupon_url(@coupon)
    add_breadcrumb 'Edit'
    authorize @coupon
    respond_with @coupon
  end

  # POST /coupons
  def create
    @coupon = policy_scope(Coupon).new(coupon_params)
    authorize @coupon
    @coupon.save
    respond_with @coupon,
      location: admin_coupons_url,
      error: 'Unable to add coupon.'
  end

  # PATCH/PUT /coupons/1
  def update
    @coupon.update(coupon_params)
    respond_with @coupon,
      location: admin_coupons_url,
      error: 'Unable to save coupon.'
  end

  # DELETE /coupons/1
  def destroy
    if @coupon.destroy
      flash[:notice] = "#{@coupon.code} has been deleted."
    end
    respond_with @coupon,
      location: admin_coupons_url,
      error: 'Unable to remove coupon.'
  end

private
  def load_coupon
    @coupon = policy_scope(Coupon).find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(
      *policy(@coupon || Coupon).permitted_attributes
    )
  end
end
