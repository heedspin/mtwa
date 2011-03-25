class HomeController < ApplicationController
  def index
    cache_control
    @news_items = NewsItem.not_deleted.with_permissions_to(:read).by_position.on_home_page.scoped(:limit => 3)
  end  
end