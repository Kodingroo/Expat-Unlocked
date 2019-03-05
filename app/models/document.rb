class Document < ApplicationRecord
  has_many :user_documents
  validates :jp_name, uniqueness: true, presence: true
end
