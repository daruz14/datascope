json.extract! user, :id, :name, :lastname, :phone, :created_at, :updated_at
json.url user_url(user, format: :json)
