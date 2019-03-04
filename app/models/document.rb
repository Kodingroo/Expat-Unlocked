class Document < ApplicationRecord
  has_many :user_documents

  validates :doc_name, uniqueness: true, presence: true
end
