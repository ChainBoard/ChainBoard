# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'comments#index'

  namespace :api do
    resources :comments, only: %w[index create]
  end
end
