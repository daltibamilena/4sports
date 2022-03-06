class Product < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :image_url, presence: true
	validates :price, numericality: true
end
