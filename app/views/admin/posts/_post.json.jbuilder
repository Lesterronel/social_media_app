json.extract! post, :id, :name, :content, :publish_date, :active, :featured, :boolean, :permalink, :created_at, :updated_at
json.url post_url(post, format: :json)
