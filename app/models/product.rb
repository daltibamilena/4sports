class Product < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :price, presence: true, format: {with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/}, numericality: {greater_than: 0, less_than: 1000000}

  def self.find_product(value)
    where("title ILIKE ? OR description ILIKE ?", "%#{value}%", "%#{value}%")
  end
end
