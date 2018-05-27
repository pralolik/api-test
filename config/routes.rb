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
  get 'student', to: 'student#index'
  get 'student/lessons', to: 'student#show_lessons'
  get 'student/lessons/:id', to: 'student#lesson_details'
  get 'student/test/:id', to: 'student#start_test'
  get 'student/tests', to: 'student#get_tests'
  put 'student/test/update/:variant_id', to: 'student#update_test'
  post 'student/test/end/:variant_id', to: 'student#end_test'
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
  get 'teacher', to: 'teacher#index'
  get 'teacher/lessons', to: 'teacher#show_lessons'
  get 'teacher/lessons/:id', to: 'teacher#lesson_details'
  get 'teacher/lessons/:id/group/:group', to: 'teacher#lesson_group_people_list'

end
