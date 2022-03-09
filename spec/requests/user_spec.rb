require "rails_helper"

RSpec.describe User, type: :request do
  context "when not signed" do
    let!(:product) { Product.create(title: "Bola", description: "Quadrada", image_url: "someurl", price: 20.40) }

    it "when create a product" do
      headers = {"ACCEPT" => "application/json"}
      post "/products", params: {product: {title: "Taco", description: "Para baseball", image_url: "someurl", price: 40.50}}, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "when update a product" do
      headers = {"ACCEPT" => "application/json"}
      put "/products/#{product.id}", params: {product: {price: "30.40"}}, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "when delete a product" do
      headers = {"ACCEPT" => "application/json"}
      delete "/products/#{product.id}", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "when search values" do
      get "/products"
      expect(response).to have_http_status(:ok)
    end

    it "when access dashboard" do
      get "/dashboard"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "when signed in as user" do
    before(:each) do
      user = User.create(email: "test@test.com", password: "password", password_confirmation: "password") ## uncomment if not using FactoryBot
      sign_in user
    end

    let!(:product) { Product.create(title: "Bola", description: "Quadrada", image_url: "someurl", price: 20.40) }

    it "when create a product" do
      headers = {"ACCEPT" => "application/json"}
      post "/products", params: {product: {title: "Taco", description: "Para baseball", image_url: "someurl", price: 40.50}}, headers: headers
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "when update a product" do
      headers = {"ACCEPT" => "application/json"}
      put "/products/#{product.id}", params: {product: {price: "30.40"}}, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "when delete a product" do
      headers = {"ACCEPT" => "application/json"}
      delete "/products/#{product.id}", headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "when search values" do
      get "/products"
      expect(response).to have_http_status(:ok)
    end

    it "when access dashboard" do
      get "/dashboard"
      expect(response).to redirect_to(products_url)
    end
  end

  context "when signed in as admin" do
    before(:each) do
      user = User.create(email: "test@test.com", password: "password", password_confirmation: "password", admin: true) ## uncomment if not using FactoryBot
      sign_in user
    end

    let!(:product) { Product.create(title: "Bola", description: "Quadrada", image_url: "someurl", price: 20.40) }

    it "when search values" do
      get "/products"
      expect(response).to have_http_status(:ok)
    end

    it "successfuly creates a product" do
      headers = {"ACCEPT" => "application/json"}
      post "/products", params: {product: {title: "Taco", description: "Para baseball", image_url: "someurl", price: 40.50}}, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
    end

    it "cannot create a product" do
      headers = {"ACCEPT" => "application/json"}
      post "/products", params: {product: {title: "Taco", description: "Para baseball", price: 40.50}}, headers: headers
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "update a product with valid param" do
      headers = {"ACCEPT" => "application/json"}
      put "/products/#{product.id}", params: {product: {price: 30.45}}, headers: headers
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(json[:price]).to eq("30.45")
    end

    it "update a product with invalid param" do
      headers = {"ACCEPT" => "application/json"}
      put "/products/#{product.id}", params: {product: {price: "-"}}, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "delete a product" do
      headers = {"ACCEPT" => "application/json"}
      delete "/products/#{product.id}", headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
    end
  end
end
