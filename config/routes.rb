Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  root 'home#index'
  post '/send_email', to: 'home#send_email'
  post '/preview_email', to: 'home#preview_email'

end
