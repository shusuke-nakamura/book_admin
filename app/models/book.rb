class Book < ApplicationRecord
  scope :costly, -> {where("price > ?", 3000)}
  scope :written_about, -> (them) {where("name like ?", "%#{them}%")}

  belongs_to :publisher
end
