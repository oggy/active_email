root = ENV['ROOT']

generate 'rspec'

# Install plugin.
run "ln -s #{root} #{root}/spec_integration/tmp/vendor/plugins/active_email"

# Move *.rake files' content to Rakefile, or else they'll be picked up
# twice--once directly, and once through the plugin.
run "cat lib/tasks/*.rake >> Rakefile && rm -f lib/tasks/*.rake"

# Copy our application files in.
system "cp -R #{root}/spec_integration/files/* ."

# Create the schema file.
rake 'db:migrate'
