# frozen_string_literal: true

source "https://rubygems.org"

# gemspec
gem "jekyll", "~> 4.3.4"
gem "jekyll-theme-chirpy", "~> 7.4.0"
gem "jekyll-feed" , "~> 0.12"
gem "logger"
gem "html-proofer", "~> 5.0", group: :test

# Use SassC via jekyll-sass-converter 2.x to avoid native
# sass-embedded downloads/builds on some Linux platforms.
gem "jekyll-sass-converter", "~> 2.2"

# Ruby 3.x no longer ships WEBrick in stdlib.
gem "webrick", "~> 1.8"

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.2.0", :platforms => [:mingw, :x64_mingw, :mswin]
