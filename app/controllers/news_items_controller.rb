class NewsItemsController < ApplicationController
  filter_access_to_defaults

  def index
    cache_control
    respond_to do |f|
      f.html do
        @news_items = NewsItem.not_deleted.with_permissions_to(:read).by_position
        @news_items = @news_items.paginate(:all,
                                           :page => params[:page],
                                           :per_page => 50)
      end
    end
  end

  def show
    @news_item = current_object
  end

  def new
    @news_item = build_object
  end

  def edit
    @news_item = current_object
  end

  def create
    @news_item = build_object

    if @news_item.save
      flash[:notice] = 'News Item was successfully created.'
      if params[:commit] == 'Save & Edit'
        redirect_to(edit_news_item_url(@news_item, :return_to => params[:return_to]))
      else
        redirect_back_or_default(news_item_url(@news_item))
      end
    else
      render :action => "new"
    end
  end

  def update
    @news_item = current_object

    respond_to do |format|
      if @news_item.update_attributes(params[:news_item])
        flash[:notice] = 'News Item was successfully updated.'
        format.html {
          if params[:commit] == 'Save & Edit'
            redirect_to(edit_news_item_url(@news_item, :return_to => params[:return_to]))
          else
            redirect_back_or_default(news_item_url(@news_item))
          end
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def move
    @news_item = current_object
    @news_item.move!(params[:direction])
    redirect_back_or_default(news_items_url)
  end

  def fix_positions
    position = 0
    changed = 0
    @news_items = NewsItem.not_deleted.by_position.each do |news_item|
      news_item.position = (position += 1)
      if news_item.changed?
        changed += 1
        news_item.save
      end
    end
    flash[:notice] = "Repositioned #{changed} News Items"
    redirect_to news_items_url
  end

  def destroy
    @news_item = current_object
    @news_item.destroy

    respond_to do |format|
      format.html { redirect_to(news_items_url) }
    end
  end

  protected

    # layout :choose_layout
    # def choose_layout
    #   if [:new, :edit].include?(action_name.to_sym)
    #     'application'
    #   else
    #     'two_columns'
    #   end
    # end

end
