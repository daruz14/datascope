class Event < ApplicationRecord
  has_many :attendances
  has_many :users, through: :attendances

  scope :in_same_company_as, ->(user) {
    joins(:users).where(users: { company: user.company }).distinct
  }

  scope :today, -> { where('start_date >= ? AND start_date <= ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day).order(start_date: :asc) }

  scope :from_today, -> { where('start_date >= ?', Time.zone.now.beginning_of_day).order(start_date: :asc) }
end
