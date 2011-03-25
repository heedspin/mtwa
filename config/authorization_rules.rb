authorization do
  
  role :guest do
    has_permission_on :users, :to => :make
    has_permission_on :user_verifications, :to => :show
    has_permission_on :displays, :to => [:read, :tft, :module, :glass, :small_tft, :custom, :oled, :extreme]
    has_permission_on :content_modules, :to => :read
    has_permission_on :contact_us_notes, :to => :make
    has_permission_on :quote_requests, :to => :make
    has_permission_on :news_items, :to => :read do
      if_attribute :status_id => is {Status.published.id}
    end
  end

  role :user do
    has_permission_on [:users, :users_password], :to => [:show,:update,:destroy] do
      if_attribute :id => is {user.id}
    end
    has_permission_on :log_events, :to => :create
    if !Rails.env.production?
      has_permission_on :users, :to => :switch
    end
    has_permission_on :user_messages, :to => :manage do
      if_attribute :user_id => is {user.id}
    end
  end

  role :admin do
    includes :user, :guest
    has_permission_on :users_password, :to => [:manage, :update_without_current_password]
    has_permission_on :users, :to => [:manage, :set_role, :switch, :verify, :delete, :message]
    has_permission_on :log_events, :to => :manage
    has_permission_on :messages, :to => :manage
    has_permission_on :user_messages, :to => [:manage, :manage_all]
    has_permission_on :displays, :to => :manage
    has_permission_on :display_catalogs, :to => :manage
    has_permission_on :content_modules, :to => :manage
    has_permission_on :contact_us_notes, :to => :manage
    has_permission_on :quote_requests, :to => :manage
    has_permission_on :news_items, :to => :read do
      if_attribute :status_id => is_in {[Status.published.id, Status.draft.id]}
    end
    has_permission_on :news_items, :to => :manage
  end
end
 
privileges do
  privilege :manage, :includes => [:make, :read, :update, :destroy, :move, :fix_positions]
  privilege :read, :includes => [:index, :show]
  privilege :make, :includes => [:new, :create, :thanks]
  privilege :update, :includes => :edit
  privilege :set_role
end