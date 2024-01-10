class Event < ApplicationRecord
  has_many :attendances
  has_many :users, through: :attendances
  validate :no_overlapping_events, on: :create
  validate :end_date_after_start_date, on: :create
  geocoded_by :address

  scope :in_same_company_as, ->(user) {
    joins(:users).where(users: { company: user.company }).distinct
  }

  scope :today, -> { where('start_date >= ? AND start_date <= ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day).order(start_date: :asc) }

  scope :from_today, -> { where('start_date >= ?', Time.zone.now.beginning_of_day).order(start_date: :asc) }
  
  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add :end_date, "La fecha de fin del evento debe ser después de la de inicio"
    end
  end

  def no_overlapping_events
    if Event.joins(:attendances)
      .where(attendances: { user_id: user_ids })
      .where('events.start_date <= ? AND events.end_date >= ?', end_date, start_date)
      .exists?

      errors.add(:base, 'Existen usuarios con colisión de horarios, intenta con uno con disponibilidad para todos')
    end
  end
end
