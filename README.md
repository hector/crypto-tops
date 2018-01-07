```bash
# Clone the repo
git clone git_address
cd project_directory

# Install and use the ruby version specified in .ruby-version
# Recommended libraries: chruby + ruby-install
# It should work with other ruby versions but it have not been tested

# Install bundler
gem install bundler

# Install project dependencies
bundle install

# Create development database schema
bundle exec rake db:setup

# Typical steps to generate data
bundle exec rake db:index
bundle exec rake results
```