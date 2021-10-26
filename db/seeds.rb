# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(name:"admin user",email:"admin@email.com",password:"password",password_confirmation:"password",admin:true)

User.create!(name:"test user",email:"testuser@email.com",password:"password",password_confirmation:"password")

user.schedules.create(starttime:Time.current,endtime:Time.current+3.hours,title:"sample plan",things:"was machst du?",schedule_day:Date.today)
