class Product < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :price, presence: true, format: {with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/}, numericality: {greater_than: 0, less_than: 1000000}

  def self.find_by_title(value)
    where("title ILIKE ?", "%#{value}%")
  end
end
