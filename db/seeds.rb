# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Comment.exists?
  Comment.create(body: 'root',
                 user_display_name: 'root',
                 user_name: 'root')

  if Rails.env == 'development'
    (1..100).each do |i|
      Comment.create(body: "body#{i}",
                     user_display_name: "udn#{i}",
                     user_name: "un#{i}",
                     comment: Comment.find([1, i - (i % 6) - 1].max))
    end
  end
end
