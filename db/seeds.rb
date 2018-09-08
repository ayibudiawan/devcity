# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# id: integer, username: string, fullname: string, gender: string, date_of_birth: date,
# created_at: datetime, updated_at: datetime, email: string, encrypted_password: string,
# reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime,
# sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet,
# last_sign_in_ip: inet, confirmation_token: string, confirmed_at: datetime, confirmation_sent_at: datetime,
# unconfirmed_email: string, bio: text, profile_picture: string

# id: integer, requestor_id: integer, target_id: integer, is_friend: boolean,
# is_subscribe: boolean, is_block: boolean, created_at: datetime, updated_at: datetime

emails = ["andy@devcity.co.id", "john@devcity.co.id", "lisa@devcity.co.id", "kate@devcity.co.id"]
ActiveRecord::Base.connection.execute("TRUNCATE users RESTART IDENTITY")
users = User.create([
  {
    email: emails[0],
    password: "andy12345",
    username: "andy-dev",
    fullname: "Andy",
    gender: "Male",
    bio: BetterLorem.p(1, true, true),
    password_confirmation: 'andy12345',
    confirmed_at: Time.now.utc
  },
  {
    email: emails[1],
    password: "john12345",
    username: "john-dev",
    fullname: "John",
    gender: "Male",
    bio: BetterLorem.p(1, true, true),
    password_confirmation: 'john12345',
    confirmed_at: Time.now.utc
  },
  {
    email: emails[2],
    password: "lisa12345",
    username: "lisa-dev",
    fullname: "Lisa",
    gender: "Female",
    bio: BetterLorem.p(1, true, true),
    password_confirmation: 'lisa12345',
    confirmed_at: Time.now.utc
  },
  {
    email: emails[3],
    password: "kate12345",
    username: "kate-dev",
    fullname: "Kate",
    gender: "Female",
    bio: BetterLorem.p(1, true, true),
    password_confirmation: 'kate12345',
    confirmed_at: Time.now.utc
  },
])

ActiveRecord::Base.connection.execute("TRUNCATE posts RESTART IDENTITY")
posts = Array.new(20) { emails[rand(0...4)] }
posts.each do |post|
  Post.create(:description => BetterLorem.p(1, true, true), :user_id => User.find_by_email(post).id)
end

ActiveRecord::Base.connection.execute("TRUNCATE activities RESTART IDENTITY")
Activity.create(:requestor_id => User.find_by_email(emails[0]).id, :target_id => User.find_by_email(emails[1]).id, :is_friend => true, :is_subscribe => true)
Activity.create(:requestor_id => User.find_by_email(emails[0]).id, :target_id => User.find_by_email(emails[2]).id, :is_friend => true)
Activity.create(:requestor_id => User.find_by_email(emails[1]).id, :target_id => User.find_by_email(emails[2]).id, :is_friend => true)
Activity.create(:requestor_id => User.find_by_email(emails[2]).id, :target_id => User.find_by_email(emails[1]).id, :is_subscribe => true)
Activity.create(:requestor_id => User.find_by_email(emails[0]).id, :target_id => User.find_by_email(emails[2]).id, :is_friend => true, :is_block => true)
Activity.create(:requestor_id => User.find_by_email(emails[0]).id, :target_id => User.find_by_email(emails[3]).id, :is_block => true)
