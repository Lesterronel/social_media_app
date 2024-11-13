namespace :site, path: '/' do
    resources :posts, param: :permalink
end