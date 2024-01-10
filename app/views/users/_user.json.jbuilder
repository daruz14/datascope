json.extract! user, :id, :name, :lastname, :email, :company
json.url user_url(user, format: :json)