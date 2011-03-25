class QuoteRequestsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]
  filter_access_to :all

  def new
    @quote_request = build_object
  end

  def create
    @quote_request = build_object

    if @quote_request.save
      redirect_to quote_request_thanks_url(:return_to => params[:return_to])
    else
      render :action => "new"
    end
  end

  def index
    @quote_requests = QuoteRequest.not_deleted.paginate(:all,
                                                        :order => 'updated_at desc',
                                                        :page => params[:page],
                                                        :per_page => 50)
  end
  
  def show
    @quote_request = current_object
  end
  
  def destroy
    current_object.destroy

    respond_to do |format|
      format.html { redirect_to(quote_requests_url) }
    end
  end

  protected

    def banner
      @banner || '/images/banners/quote_requests.jpg'
    end

#     layout :choose_layout
#     def choose_layout
#       if [:new].include?(action_name.to_sym)
#         'two_columns'
#       else
#         'application'
#       end
#     end
end
