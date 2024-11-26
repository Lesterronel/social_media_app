# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = User.limit(5).to_a

20.times do
  name = Faker::Lorem.sentence(word_count: 3) # Generate a random title
  Post.create!(
    name: name,
    content: Faker::Lorem.paragraph(sentence_count: 5), # Random content
    publish_date: Faker::Date.between(from: 1.year.ago, to: Date.today), # Random date in the past year
    active: [true, false].sample, # Random boolean
    featured: [true, false].sample, # Random boolean
    permalink: name.parameterize, # Generate permalink based on name
    user_id: users.sample.id # Assign to a random user
  )
end