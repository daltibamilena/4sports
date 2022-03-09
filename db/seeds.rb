10.times do
  Product.create(title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price: Faker::Commerce.price,
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ["sports"]))
end
