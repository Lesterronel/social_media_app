Rails.application.routes.draw do
  root "site/home#index"

  resources :comments
  get 'posts/:post_id/comments', to: 'comments#index_for_post', as: :post_comments
  get 'posts/:post_id/new_comments', to: 'comments#new', as: :post_new_comments

  draw :site
  draw :admin
end
