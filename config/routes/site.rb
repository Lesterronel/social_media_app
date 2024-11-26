devise_for :users,
    controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
    }

namespace :site, path: '/' do
    resources :posts do
        resources :comments, only: [:new, :create] 
        member do
            post :edit
            get :content_full
            patch :like
        end
    end
end