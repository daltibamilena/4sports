class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

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
        render turbo_stream: turbo_stream.update("search_results", partial: "products/search_product", locals: {products: @products})
      end
    end
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: {status: "SUCCESS", data: product}, status: :ok
    else
      render json: {status: "ERROR", data: product.errors}, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: {status: "SUCCESS", data: product}, status: :ok
    else
      render json: {status: "ERROR", data: product.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    render json: {status: "SUCCESS", message: "Deleted product", data: product}, status: :ok
  end

  private

  def product_params
    params.permit(:title, :description, :image_url, :price)
  end
end
