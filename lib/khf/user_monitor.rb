#extend activerecord to auto-populate created_by and updated_by like it does for created_at
module ActiveRecord
  module UserMonitor
    def self.included(base)
      base.class_eval do
        alias_method_chain :create, :user
        alias_method_chain :update, :user
      end
      
      def current_user
        Thread.current['user']
      end
    end

    def create_with_user
      if !current_user.nil?
        self[:created_by] = current_user.id if respond_to?(:created_by) && created_by.nil?
        self[:updated_by] = current_user.id if respond_to?(:updated_by)
      end
      create_without_user
    end
    
    def update_with_user
      self[:updated_by] = current_user.id if respond_to?(:updated_by) && !current_user.nil?
      update_without_user
    end
    
    def created_by
      begin
        current_user.class.find_by_id(self[:created_by]) if current_user
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
   
    def updated_by
      begin
        current_user.class.find_by_id(self[:updated_by]) if current_user
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end