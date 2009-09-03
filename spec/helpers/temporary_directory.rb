module Helpers
  #
  # Provides an empty directory for each test run.  The path is given
  # by #temporary_directory.
  #
  module TemporaryDirectory
    def self.included(base)
      base.before{reset_temporary_directory}
      base.after{remove_temporary_directory}
    end

    def temporary_directory
      "#{PLUGIN_ROOT}/spec/tmp"
    end

    private  # -------------------------------------------------------

    def reset_temporary_directory
      FileUtils.rm_rf(temporary_directory)
      FileUtils.mkdir_p(temporary_directory)
    end

    def remove_temporary_directory
      FileUtils.rm_rf(temporary_directory)
    end
  end
end
