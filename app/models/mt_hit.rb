class MtHit < ApplicationModel
  include ActionController::UrlWriter
  validates_presence_of :task_type, :hit_url, :hit_title, :hit_description, :hit_id, :hit_reward, :hit_num_assignments, :hit_lifetime, :form_url
  
  scope :in_progress, :conditions => 'mt_hits.complete = false or mt_hits.complete is null'
  
  default_value_for :sandbox do
    RTurk.sandbox?
  end
  default_value_for :hit_num_assignments do
    1
  end
  default_value_for :hit_reward do
    0.0
  end
  default_value_for :hit_lifetime do
    1.days.seconds.to_i
  end

  def rturk_hit
    RTurk::Hit.find(self.hit_id)
  end

  def expire!
    if hit = self.rturk_hit
      hit.expire! if (hit.status == "Assignable" || hit.status == 'Unassignable')
      hit.assignments.each do |assignment|
        logger.info "Assignment status : #{assignment.status}"
        assignment.approve!('__clear_all_turks__approved__') if assignment.status == 'Submitted'
      end
      self.update_attributes(:complete => true)
    end
  end

  def task_class
    self.task_type.constantize
  end
  
  def task_object_name
    ActiveModel::Naming.singular(self.task_class)
  end
  
  def assignments
    self.rturk_hit.assignments
  end
  
  def answers
    if @answers.nil?
      @answers = task_class.for_hit(self)
      if self.in_progress? and (amnts = self.assignments)
        amnts.each do |assignment|
          if assignment.status == 'Submitted'
            unless answer = @answers.detect { |a| a.assignment_id == assignment.id }
              params = assignment.answers.map { |k, v| "#{CGI::escape(k)}=#{CGI::escape(v)}" }.join('&')
              param_hash = Rack::Utils.parse_nested_query(params)
              @answers.push answer = task_class.create(param_hash[self.task_object_name])
              answer.assignment_id = assignment.id
              answer.mt_hit = self
            end
            # answer.mt_answer_status = MtAnswerStatus.find_by_name(assignment.status)
            answer.save
          end
        end
      end
    end
    @answers
  end
  
  def in_progress?
    !self.complete?
  end

  HIT_FRAMEHEIGHT = 1000

  def self.make(args)
    cookie = (args.delete(:cookie) || {}).clone
    mt_hit = MtHit.new(args)
    host = RTurk.sandbox? ? AppConfig.local_hostname : AppConfig.production_hostname
    url_args = cookie.merge(:host => host, :protocol => RTurk.sandbox? ? 'http' : 'https')
    mt_hit.form_url = mt_hit.send("new_#{mt_hit.task_object_name}_url", url_args)

    h = RTurk::Hit.create(:title => mt_hit.hit_title) do |hit|
      hit.assignments = mt_hit.hit_num_assignments
      hit.description = mt_hit.hit_description
      hit.reward      = mt_hit.hit_reward
      hit.lifetime    = mt_hit.hit_lifetime
      hit.question(mt_hit.form_url, :frame_height => HIT_FRAMEHEIGHT)
    end
    mt_hit.hit_id = h.id
    mt_hit.hit_url = h.url
    mt_hit.save
    mt_hit
  end
end
# == Schema Information
#
# Table name: mt_hits
#
#  id                  :integer(4)      not null, primary key
#  hit_url             :string(255)
#  sandbox             :boolean(1)
#  task_type           :string(255)
#  hit_title           :text
#  hit_description     :text
#  hit_id              :string(255)
#  hit_reward          :decimal(10, 2)
#  hit_num_assignments :integer(4)
#  hit_lifetime        :integer(4)
#  form_url            :string(255)
#  complete            :boolean(1)
#  created_at          :datetime
#  updated_at          :datetime
#
