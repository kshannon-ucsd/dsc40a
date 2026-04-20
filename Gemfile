# frozen_string_literal: true

source "https://rubygems.org"
ruby File.read(".ruby-version").strip

gem "jekyll", "~> 4.4"
# Liquid 4.0.3 calls String#tainted?, removed in Ruby 3.2+. 4.0.4 fixes it.
gem "liquid", ">= 4.0.4"

# Jekyll Theme
gem "just-the-docs", "~> 0.4.0.rc3"
# No need to include github-pages gem
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

gem "webrick", "~> 1.7"

# Ruby 3.4 removed these from the default stdlib; Jekyll 4.3 / Liquid 4.0 still require them.
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"
