json.extract! event, :id, :title, :description, :start_date, :end_date, :address
json.weather @weather
json.participants event.users.map { |user| { email: user.email, name: user.name, lastname: user.lastname } }
json.url event_url(event, format: :json)
