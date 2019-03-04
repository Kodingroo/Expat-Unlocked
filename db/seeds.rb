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
UserDocument.destroy_all
Document.destroy_all
User.destroy_all

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

