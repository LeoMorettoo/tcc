json.array!(@users) do |user|
  json.extract! user, :id, :name, :login, :password, :email, :created_at, :updated_at, :deleted_at, :status
  json.url user_url(user, format: :json)
end
