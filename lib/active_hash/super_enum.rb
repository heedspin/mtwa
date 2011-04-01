module ActiveHash
  module SuperEnum
    def self.included(base)
      base.send(:include, Enum)
      base.extend(Methods)
    end

    module Methods
      def insert(record)
        super
        enum_value = record.attributes[@enum_accessor]
        constant = constant_for(enum_value)
        return nil if constant.blank?
        downer_constant = record.attributes[:method] || constant.downcase
        self.class_eval <<-TEXT
        def #{downer_constant}?
          self.id == #{constant}.id
        end
        class << self
          def #{downer_constant}
            #{constant}
          end
        end
        TEXT
      end
    end
  end
end
