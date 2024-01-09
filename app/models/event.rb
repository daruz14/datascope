class Event < ApplicationRecord
  has_many :attendances
  has_many :users, through: :attendances

  scope :in_same_company_as, ->(user) {
    joins(:users).where(users: { company: user.company }).distinct
  }
end
