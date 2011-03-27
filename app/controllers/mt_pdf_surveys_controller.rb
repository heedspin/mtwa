class MtPdfSurveysController < ApplicationController
  skip_before_filter :require_login, :only => [:new]

  def new
    @assignment_id = params[:assignmentId]
    @disabled      = Turkee::TurkeeFormHelper::disable_form_fields?(@assignment_id)

    # If you wanted to find the associated turkee_task, you could do a find by hitId
    #  Not necessary in a simple example.
    # @turkee_task   = Turkee::TurkeeTask.find_by_hit_id(params[:hitId]).id rescue nil
    @survey = MtPdfSurvey.new
    render :layout => false
  end
  
  protected
  
    def mt_url
      'https://workersandbox.mturk.com/mturk/externalSubmit'
      # 'http://www.mturk.com/mturk/externalSubmit'
    end
    helper_method :mt_url
end
