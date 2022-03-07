require 'rails_helper'

describe "Product" , :type => :request do 
  context "Create product" do
    it "creates a product" do
      headers = { "ACCEPT" => "application/json" }
      post "/api/v1/products", :params => { :title => "Taco", :description => "Para baseball", :image_url => "someurl", :price => 40.50 }, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
    end

    it "when passes bad params to request" do
      headers = { "ACCEPT" => "application/json" }
      post "/api/v1/products", :params => { :title => [], :description => "Para baseball", :image_url => "someurl", :price => 40.50 }, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  context "Update product" do
    let!(:product) { Product.create(title: "Bola", description: "Quadrada", image_url: "someurl", price: 20.40)}
    it "update a product with valid param" do
      headers = { "ACCEPT" => "application/json" }
      put "/api/v1/products/#{product.id}", :params => { :price => 30.45 }, :headers => headers
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(json[:data][:price]).to eq("30.45")
    end
    it "update a product with invalid param" do
      headers = { "ACCEPT" => "application/json" }
      put "/api/v1/products/#{product.id}", :params => { :price => "-" }, :headers => headers
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:data][:price]).to eq(["is invalid", "is not a number"])
    end
  end
end