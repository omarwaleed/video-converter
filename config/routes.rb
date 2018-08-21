Rails.application.routes.draw do

  
  post 'video/check' => 'video#check'
  post 'video/convert' => 'video#convert'
  # get 'video/check'
  # get 'video/convert'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
