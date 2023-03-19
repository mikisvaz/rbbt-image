# Basic alpine setup
apk add ruby ruby-dev  # Ruby
apk add git make gcc g++ cmake # Building
apk add bzip2 bzip2-dev zlib zlib-dev # Libs
apk add bash wget curl rsync gnu-libiconv  # Tools

gem install rbbt-util rbbt-sources
gem install RubyInline

gem install specific_install hoe minitest
gem specific_install -l https://github.com/mikisvaz/lockfile.git
gem specific_install -l https://github.com/mikisvaz/rubyinline.git

rm -Rf /usr/lib/ruby/gems/*/doc /usr/lib/ruby/gems/*/cache

grep rbbt_environment /etc/rbbt_environment || echo "[ -f ~/.rbbt/etc/environment ] && . ~/.rbbt/etc/environment" >> "/etc/rbbt_environment"
grep rbbt_environment /etc/profile || echo echo "source /etc/rbbt_environment" >> /etc/profile

# Main alpine setup
apk add xvfb bison autoconf rsync curl openssl numactl zlib-dev zlib yaml-dev openssl xz-dev xz-libs libffi tcsh gawk pandoc libtbb-dev yaml libxml2-dev libxml2 shared-mime-info
