class Book < ApplicationRecord
  scope :costly, -> {where("price > ?", 3000)}
  scope :written_about, -> (them) {where("name like ?", "%#{them}%")}

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :name, presence: true
  validates :name, lenth: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
end
