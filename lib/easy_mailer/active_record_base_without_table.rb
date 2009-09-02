module EasyMailer
  #
  # An abstract subclass of ActiveRecord::Base with the database
  # interaction stubbed out.  From a fork of Jonathan Viney's
  # active_record_base_without_table plugin at:
  # http://github.com/sofadesign/active_record_base_without_table
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

      def column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
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
