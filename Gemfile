# If you have OpenSSL installed, we recommend updating
# the following line to use "https"
source 'https://rubygems.org'
source 'https://rails-assets.org'

gem "middleman", "~> 3.3.10"

gem 'compass', '~> 1'

# Live-reloading plugin
gem "middleman-livereload"
# Duck: lock version, later ones require a more recent Ruby
gem "rb-inotify", "~> 0.9.10"

# Cross-templating language block fix for Ruby 1.8
platforms :mri_18 do
  gem "ruby18_source_location"
end

# For faster file watcher updates for people using Windows
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]


#####
# General plugins

# Blog plugin
gem "middleman-blog"
#gem "middleman-blog-drafts"
#gem "middleman-blog-authors"

# Thumbnailer
#gem "middleman-thumbnailer", github: "nhemsley/middleman-thumbnailer"

# favicon support (favicon PNG should be 144×144)
gem "middleman-favicon-maker"

# HTML & XML parsing smarts
gem "nokogiri", "~> 1.13.9"
gem 'mini_portile'

# Syntax highlighting
gem "middleman-syntax"

# For feed.xml.builder
gem "builder", "~> 3.0"

# Better JSON lib
gem "oj", "~> 3.3"

# Lock jQuery to 1.x, for better IE support (6 - 8)
# Fixes and features are backported from 2.x to 1.x; only diff is IE support.
# see http://blog.jquery.com/2013/01/15/jquery-1-9-final-jquery-2-0-beta-migrate-final-released/
gem 'rails-assets-jquery', '~> 1'

# Friendly date library
gem 'chronic'

#####
# Bootstrap

# Bootstrap, as SASS
# Duck: 3.4 uses sassc which requires a more recent Ruby
gem "bootstrap-sass", "~> 3.3.7"


#####
# Formats

# haml
gem "haml", "~> 4.0"

# less (css)
gem "therubyracer"
gem "less"

# asciidoctor
gem "asciidoctor"

gem "coderay"
gem "stringex"

# Markdown
# pinned to fix issue with https://github.com/gettalong/kramdown/pull/513
# and https://github.com/redhat-openstack/website/pull/1218
gem "kramdown", "~> 1.16.0"

# pinned to work on the CentOS 7 builder
gem "hitimes", "~> 1.2.6"

gem 'open-uri-cached'

gem 'font-awesome-middleman'

# RSS/Atom parsing
gem "feedjira"

gem 'rails-assets-bootstrap-sortable'

gem 'rails-assets-momentjs'
# pinned to work on the CentOS 7 builder
gem "rails-assets-fullcalendar", "~> 2.9.1"
gem 'icalendar', '~> 1.5'

gem 'slop', '~> 4'
gem 'launchy'

