module EasyMailer
  #
  # An abstract subclass of ActiveRecord::Base with the database
  # interaction stubbed out.
  #
  # Based on Jonathan Viney's active_record_base_without_table.
  #
  class ActiveRecordBaseWithoutTable < ActiveRecord::Base
    self.abstract_class = true

    def create_or_update_without_callbacks
      errors.empty?
    end

    class << self
      def columns()
        @columns ||= []
      end

      def attribute(name, sql_type = nil, default = nil)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, true)
        reset_column_information
      end

      # Reset everything, except the column information
      def reset_column_information
	columns = @columns
	super
	@columns = columns
      end
    end
  end
end
