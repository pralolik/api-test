Rails.application.routes.draw do
  #Auth area
  post 'authenticate', to: 'authentication#authenticate'
  post 'logout', to: 'authentication#logout '
  #post 'register', to: 'authentication#register'

  #admin area
  namespace :admin do
      resources :users
      resources :students
      resources :teachers
      resources :groups
      resources :lessons
  end
  ##students part
  get 'admin/students/flow/:flow', to: 'admin/students#flow'
  get 'admin/students/group/:group', to: 'admin/students#group'
  get 'admin/students/:id/lessons', to: 'admin/students#lessons'
  put 'admin/students/:id/group/', to: 'admin/students#set_group'
  delete 'admin/students/:id/group/', to: 'admin/students#delete_group'
  ##teacher part
  get 'admin/teachers/:id/lessons', to: 'admin/teachers#get_lessons'
  ##user part
  put 'admin/users/:id/role', to: 'admin/users#set_role'

  #teacher are
  namespace :teacher do
    resources :tests
    resources :questions
    resources :question_selects
    resources :variants
  end

end
