# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(email: "admin@example.com", password: "12345678", first_name: "Admin", last_name: "Admin", date_of_birth: "1990-12-02", gender: 1, position: "", zipcode: "380061", user_type: 1, address: nil, phone_number: nil, current_club: nil, description: nil, soccer_club: nil, soccer_goal: nil)

Price.create!(name: "12 and under", price: 150)
Price.create!(name: "13 and up", price: 200)