Rails.application.routes.draw do

  resource :video do
    post 'check' => 'video#check'
    post 'convert' => 'video#convert'
  end
  # get 'video/check'
  # get 'video/convert'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
