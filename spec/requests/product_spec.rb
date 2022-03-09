require "rails_helper"

RSpec.describe Product, type: :request do
  context "when search products" do
    let!(:product) { Product.create(title: "Bola de basquete", description: "Quadrada", image_url: "someurl", price: 20.40) }
    let!(:product2) { Product.create(title: "Taco", description: "Madeira", image_url: "someurl", price: 20.40) }
    let!(:product3) { Product.create(title: "Tênis de basquete", description: "Furado", image_url: "someurl", price: 20.40) }

    it "when finds a product" do
      headers = {"ACCEPT" => "application/json"}
      post "/products/search", params: {title_search: "basq"}, headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json.count).to eq(2)
    end

    it "when finds a product with desc sort" do
      headers = {"ACCEPT" => "application/json"}
      post "/products/search", params: {title_search: "basq", sort: "DESC"}, headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json.count).to eq(2)
      expect(json.first["title"]).to eq(product3.title)
      expect(json.first["title"]).to eq(product3.title)
    end
  end
end
