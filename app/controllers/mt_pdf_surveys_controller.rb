require 'digest/md5'
class MtPdfSurveysController < ApplicationController
  layout 'mturk'
  skip_before_filter :require_login, :only => [:new]

  def new
    @assignment_id = params[:assignmentId]
    @disabled = MtHit.preview_assignment?(@assignment_id)
    @mt_hit = MtHit.find_by_hit_id(params[:hitId])
    if @assignment_id and @mt_hit
      @survey = MtPdfSurvey.new(@mt_hit.cookie)
    elsif Rails.env.development?
      @survey = MtPdfSurvey.new(:page => 6, :subpage => Subpage.second_subpage, :survey_type => SurveyType.first)
    else
      record_not_found
    end
    @upload_prefix = Digest::MD5.hexdigest("#{request.remote_addr}-#{Time.now.to_f}")
  end

  protected

    def mt_url
      'https://workersandbox.mturk.com/mturk/externalSubmit'
      # 'http://www.mturk.com/mturk/externalSubmit'
    end
    helper_method :mt_url
end
