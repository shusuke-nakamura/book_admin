class Book < ApplicationRecord
  scope :costly, -> {where("price > ?", 3000)}
  scope :written_about, -> (them) {where("name like ?", "%#{them}%")}

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validate do |book|
    if book.name.include?('exercies')
      book.errors[:name] << "I don't like exercies."
    end
  end

  before_validation :add_lovely_to_cat

  def add_lovely_to_cat
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end

  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end

  after_destroy :if => :high_price? do
    Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
    Rails.logger.warn "Please check!!"
  end

  def high_price?
    price >= 5000
  end
  
  enum sales_status: {
    reservation: 0, # 予約受付中
    now_on_sale: 1, # 販売中
    end_of_print: 2, #販売終了
  }
end
