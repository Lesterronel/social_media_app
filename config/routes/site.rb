devise_for :users,
    controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
    }

namespace :site, path: '/' do
    resources :posts do
        member do
            post :edit
            get :content_full
            patch :like
        end
    end
end