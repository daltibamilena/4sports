class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
  before_action :require_admin, except: [:index, :search]

  def index
    @products = Product.order("created_at DESC")
    respond_to do |format|
      format.html
      format.json
    end
  end

  def search
    @products = Product.find_product(params[:title_search]).order("title #{params[:sort]}")
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search_results", partial: "partials/card_product", locals: {products: @products})
      end
      format.json { render json: @products, status: :ok }
    end
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.new(product_params)
    respond_to do |format|
      if product.save
        format.html { redirect_to dashboard_url, notice: "Product was successfully created." }
        format.json { render json: product, status: :ok }
      else
        format.html { render :edit, locals: {product: @product} }
        format.json { render json: product, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    product = Product.find(params[:id])
    respond_to do |format|
      if product.update(product_params)
        format.html { redirect_to dashboard_url, notice: "Product was successfully updated." }
        format.json { render json: product, status: :ok }
      else
        format.html { render :edit, locals: {product: @product} }
        format.json { render json: product, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    product = Product.find(params[:id])
    respond_to do |format|
      if product.destroy
        format.html { redirect_to dashboard_url, notice: "Product was successfully deleted." }
        format.json { render json: product, status: :ok }
      else
        format.html { redirect_to dashboard_url, notice: "Product can not be deleted." }
        format.json { render json: product, status: :unprocessable_entity }
      end
    end
  end

  def authenticate_user!
    if user_signed_in?
      @user = current_user
    else
      head :unauthorized
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :image_url, :price)
  end
end
