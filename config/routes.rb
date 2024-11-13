Rails.application.routes.draw do
  root "site/home#index"

  draw :site
end
