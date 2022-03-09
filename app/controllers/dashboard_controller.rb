class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @products = Product.all
      @users = User.all
      respond_to do |format|
        format.html { render template: "dashboard/index", locals: {products: @products, users: @users} }
      end
    else
      redirect_to products_url
    end
  end

  def set_user_admin
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to dashboard_url, notice: "User was successfully updated." }
      else
        format.html { redirect_to dashboard_url, notice: "User can not be updated." }
      end
    end
  end

  private

  def user_params
    params.permit(:admin)
  end
end
