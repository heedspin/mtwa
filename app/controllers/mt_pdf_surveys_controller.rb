class MtPdfSurveysController < ApplicationController
  layout 'mturk'
  skip_before_filter :require_login, :only => [:new]

  def new
    @assignment_id = params[:assignmentId]
    @disabled = MtHit.preview_assignment?(@assignment_id)
    @mt_hit = MtHit.find_by_hit_id(params[:hitId])
    if @assignment_id and @mt_hit
      @survey = MtPdfSurvey.new(@mt_hit.cookie)
    else
      record_not_found
    end
  end
  
  protected
  
    def mt_url
      'https://workersandbox.mturk.com/mturk/externalSubmit'
      # 'http://www.mturk.com/mturk/externalSubmit'
    end
    helper_method :mt_url
end
