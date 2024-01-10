class EventMailer < ApplicationMailer
  def schedule_event_email(event, participant)
    @event = event
    @participant = participant

    mail(to: @participant.email, subject: 'Nuevo evento creado')
  end
end
