Starfactory::Application.routes.draw do

  concern :commentable do
    resources :comments, except: [:new]
  end

  concern :discussionable do
    resources :discussions, concerns: [:commentable], only: [:index, :show]
  end

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login
  get 'register' => 'users#new', as: :register
  resources :users
  get 'users/:token/activate' => 'users#activate', as: :user_token_activate
  resources :sessions
  resources :password_resets, path: 'passwords'

  resources :coupons, except: [:index, :show] do
    collection do
      get :check
    end
  end
  resources :discussions, except: [:index, :show]
  get 'forum' => 'discussions#forum', as: :forum
  resources :events do
    resources :registrations, only: [:edit]
  end
  get 'events/:year/:month' => 'events#index', as: :events_month
  resources :instructor_profiles, path: 'instructors'
  resources :locations
  resources :registrations, except: [:show, :new, :edit]
  resources :student_profiles, path: 'students' do
    resources :registrations, only: [:index, :show]
  end
  resources :tracks, concerns: [:discussionable]
  resources :workshops, concerns: [:votable, :discussionable] do
    member do
      put :clear_votes
    end
  end

  scope :admin do
    get '' => 'admin#index', as: :admin
    get 'coupons' => 'admin#coupons', as: :admin_coupons
    get 'discussions' => 'admin#discussions', as: :admin_discussions
    get 'events' => 'admin#events', as: :admin_events
    get 'instructors' => 'admin#instructor_profiles', as: :admin_instructors
    get 'locations' => 'admin#locations', as: :admin_locations
    get 'users' => 'admin#users', as: :admin_users
    get 'tracks' => 'admin#tracks', as: :admin_tracks
    get 'events/:event_id/registrations' => 'admin#registrations', as: :admin_event_registrations
    get 'students' => 'admin#student_profiles', as: :admin_students
    get 'workshops' => 'admin#workshops', as: :admin_workshops
    get 'tracks/:id/workshops' => 'admin#workshops', as: :admin_track_workshops
  end

  get 'faq' => 'static#faq', as: :faq
  get 'contact' => 'static#contact', as: :contact
  get 'privacy' => 'static#privacy', as: :privacy
  get 'terms' => 'static#terms', as: :terms
  get 'conduct' => 'static#conduct', as: :conduct

  get '403' => 'static#status403', as: :status_403
  get '404' => 'static#status404', as: :status_404
  get '500' => 'static#status500', as: :status_500

  root 'static#index'
  match '*', to: 'static#status404', via: '*'
end
