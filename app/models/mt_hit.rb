class MtHit < ApplicationModel
  include Rails.application.routes.url_helpers
  validates_presence_of :task_type, :hit_url, :hit_title, :hit_description, :hit_id, :hit_reward, :hit_num_assignments, :hit_lifetime, :form_url
  belongs_to :status, :class_name => 'MtHitStatus'
  has_many :s3_uploads

  scope :complete, :conditions => { :status_id => MtHitStatus.complete.id }
  scope :in_progress, :conditions => { :status_id => MtHitStatus.in_progress.id }
  scope :not_deleted, :conditions => { :status_id => [MtHitStatus.in_progress.id, MtHitStatus.complete.id] }
  scope :by_date, :order => :created_at

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
  default_value_for :status_id do
    MtHitStatus.in_progress.id
  end
  
  attr_accessor :cookie
  before_save :encode_cookie
  def encode_cookie
    self.cookie_json = self.cookie.to_json if self.cookie.present?
    true
  end
  def cookie
    @cookie ||= self.cookie_json && JSON.parse(self.cookie_json)
  end

  before_save :stringify_local_id
  def stringify_local_id
    if self.local_id.is_a?(Hash)
      self.local_id = self.class.hash_to_string(self.local_id)
    end
    true
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
      self.update_attributes(:status => MtHitStatus.complete)
    end
  end
  
  def archive!
    self.update_attributes(:status => MtHitStatus.archived)
  end
  
  def destroy
    self.update_attributes(:status => MtHitStatus.deleted)
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
      if self.status.in_progress? and (asmts = self.assignments)
        asmts.each do |assignment|
          if ['Submitted', 'Approved'].include?(assignment.status)
            unless answer = @answers.detect { |a| a.assignment_id == assignment.id }
              params = MtHit.parse_mturk_answers(assignment.answers)
              @answers.push answer = task_class.create(params[self.task_object_name])
              answer.assignment_id = assignment.id
              answer.mt_hit = self
              answer.save
            end
            # answer.mt_answer_status = MtAnswerStatus.find_by_name(assignment.status)
          end
        end
      end
    end
    @answers
  end
  
  def self.parse_mturk_answers(answers)
    params = Hash.new({})
    answers.each do |key, value|
      next unless value.present?
      if key =~ /^([^\[]+)\[(.+)\]$/
        # text_field_tag "#{object}[#{field}_#{row}_#{column}]", nil, :size => size
        object = $1
        field = $2
        if key.include?('table') and field =~ /(.+)_(.+)_(.+)/
          field = $1
          row = $2
          column = $3
          table = params[object][field] ||= []
          row = table[row.to_i] ||= []
          row[column.to_i] = value
        else
          params[object][field] = value
        end
      end
    end
    params
  end
  
  HIT_FRAMEHEIGHT = 1000

  def self.make(args)
    args[:local_id] ||= args[:cookie]
    mt_hit = MtHit.new(args)
    host = RTurk.sandbox? ? AppConfig.local_hostname : AppConfig.production_hostname
    mt_hit.form_url = mt_hit.send("new_#{mt_hit.task_object_name}_url",
                                  :host => host,
                                  :protocol => RTurk.sandbox? ? 'http' : 'https')

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
  
  def self.preview_assignment?(assignment_id)
    assignment_id.nil? || (assignment_id == 'ASSIGNMENT_ID_NOT_AVAILABLE')
  end
  
  def self.find_by_local_id(local_id)
    if local_id.is_a?(Hash)
      local_id = hash_to_string(local_id)
    end
    self.not_deleted.first :conditions => { :local_id => local_id }
  end
  
  def self.hash_to_string(hash)
    hash.keys.map { |k| "#{k}:#{hash[k]}" }.sort.join(',')
  end
  
  def to_s
    "MtHit #{id} (#{task_type})"
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
#  status_id           :integer(4)
#  local_id            :string(255)
#  cookie_json         :text
#  created_at          :datetime
#  updated_at          :datetime
#

