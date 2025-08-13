class Profile < ApplicationRecord
  belongs_to :user

  # year is integer in DB
  enum :year, {
    first_year:  1,
    second_year: 2,
    third_year:  3,
    fourth_year: 4,
    fifth_year:  5
  }, prefix: true

  MAJORS = %w[CST CT CS].freeze
  validates :major, inclusion: { in: MAJORS }
  validates :full_name, presence: true
end
