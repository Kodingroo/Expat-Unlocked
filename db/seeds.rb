# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'date'

puts 'Cleaning database...'
UserDocument.destroy_all if Rails.env.development?
Document.destroy_all if Rails.env.development?
User.destroy_all if Rails.env.development?

#USERS
puts 'Creating Users...'
user_attributes = [
  {
    first_name: 'Isaac',
    last_name: 'Hayward',
    address: 'Ojima, Tokyo',
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password'
  },
    {
    first_name:'Jack',
    last_name: 'Wuersch',
    address: 'Meguro, Tokyo',
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password'
  },
    {
    first_name: 'Sherly',
    last_name: 'Hartono',
    address: 'Shibuya, Tokyo',
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password'
  },
    {
    first_name: 'Ivan',
    last_name: 'Garcia',
    address: 'Shinjuku, tokyo',
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password'
  },
]

User.create!(user_attributes)
puts 'Finished Users!'

#DOCUMENTS
puts 'Creating Documents...'
document_attributes = [
  {
    doc_name: 'Water',
    company_name: 'Tokyo Water',
    payment_type: 'Convenience Store',
    description: Faker::TvShows::GameOfThrones.quote
  },
  {
    doc_name: 'Gas',
    company_name: 'Tokyo Gas',
    payment_type: 'Convenience Store',
    description: Faker::TvShows::GameOfThrones.quote
  },
  {
    doc_name: 'Electricity',
    company_name: 'Tokyo Electricity',
    payment_type: 'Convenience Store',
    description: Faker::TvShows::GameOfThrones.quote
  }
]

Document.create!(document_attributes)
puts 'Finished Documents!'

#USER DOCUMENTS
puts 'Creating User Documents...'
user_document_attributes = [
  {
    user_id: User.all.sample.id,
    document_id: Document.all.sample.id,
    title: 'Water',
    doc_type: 'Bill',
    photo: Faker::Internet.url,
    state: :unpaid,
    due_date: Date.today.to_s(:long),
    remaining_balance: rand(120..240),
    current_due_amount: rand(20..40),
    reminder_date: Date.today.to_s(:short)
  },
  {
    user_id: User.all.sample.id,
    document_id: Document.all.sample.id,
    title: 'Gas',
    doc_type: 'Tokyo Gas',
    photo: Faker::Internet.url,
    state: :unpaid,
    due_date: Date.today.to_s(:long),
    remaining_balance: rand(120..240),
    current_due_amount: rand(20..40),
    reminder_date: Date.today.to_s(:short)
  },
  {
    user_id: User.all.sample.id,
    document_id: Document.all.sample.id,
    title: 'Electricity',
    doc_type: 'Tokyo Electricity',
    photo: Faker::Internet.url,
    state: :unpaid,
    due_date: Date.today.to_s(:long),
    remaining_balance: rand(120..240),
    current_due_amount: rand(20..40),
    reminder_date: Date.today.to_s(:short)
  }
]

UserDocument.create!(user_document_attributes)
puts 'Finished User Documents!'

