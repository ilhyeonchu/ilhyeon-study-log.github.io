source "https://rubygems.org"

gem "jekyll", "~> 4.3.2"

# Chirpy 테마
gem "jekyll-theme-chirpy", "~> 6.0"

# 필수 플러그인
group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-archives"
  gem "jekyll-redirect-from"
end

# Windows와 JRuby는 이 gem이 필요
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# 성능 향상을 위한 gem (선택사항)
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
gem "webrick", "~> 1.8"
