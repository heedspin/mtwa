module MtTask
  def self.included(base)
    base.class_eval <<-"RUBY"
    belongs_to :mt_hit
    scope :for_hit, lambda { |hit|
      {
        :conditions => ['#{base.table_name}.mt_hit_id = (?)', hit.id]
      }
    }
    RUBY
  end
  
  def assignment
    @assignment ||= self.mt_hit.assignments.detect { |a| a.id == self.assignment_id }
  end
end
