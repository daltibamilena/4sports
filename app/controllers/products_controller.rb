class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]

  def index
    @products = Product.order("created_at DESC")
    respond_to do |format|
      format.html
      format.json
    end
  end

  def search
    @products = Product.find_by_title(params[:title_search]).order("title #{params[:sort]}")
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search_results", partial: "partials/search_product", locals: {products: @products})
      end
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
      else
        format.html { render :edit, locals: {product: @product} }
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    p params
    product = Product.find(params[:id])
    respond_to do |format|
      if product.update(product_params)
        format.html { redirect_to dashboard_url, notice: "Product was successfully updated." }
      else
        format.html { render :edit, locals: {product: @product} }
      end
    end
  end

  def destroy
    product = Product.find(params[:id])
    respond_to do |format|
      if product.destroy
        format.html { redirect_to dashboard_url, notice: "Product was successfully deleted." }
      else
        format.html { redirect_to dashboard_url, notice: "Product can not be deleted." }
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :image_url, :price)
  end
end
