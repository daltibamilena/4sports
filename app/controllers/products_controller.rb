class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    products = Product.order('created_at DESC')
    render json: {status: "Success", data:products}, status: :ok
  end



  private
  def product_params
      params.permit(:title, :description, :image_url, :price)
  end
end
