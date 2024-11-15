devise_for :users,
    controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
    }

namespace :site, path: '/' do
    
    resources :posts
end