devise_for :administrators,
    controllers: {
        sessions: 'administrator/sessions',
        registrations: 'administrator/registrations'
    }

namespace :admin do
    get "dashboard/index"
    
    resources :audittrails
    resources :posts
end