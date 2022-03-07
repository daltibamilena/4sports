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
end