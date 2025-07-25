# Basic alpine setup
apk add ruby ruby-dev  # Ruby
apk add git make gcc g++ cmake # Building
apk add bzip2 bzip2-dev zlib zlib-dev krb5 gcompat # Libs
apk add openssl1.1-compat-dev openssl1.1-compat # openssl
apk add bash openssh-client wget curl rsync gnu-libiconv  # Tools
 
echo $CUSTOM_SYSTEM_PACKAGES | sed 's/,/\n/g' | xargs apk add

gem install rbbt-util rbbt-sources
gem install RubyInline

gem install specific_install hoe minitest
gem specific_install -l https://github.com/mikisvaz/lockfile.git
gem specific_install -l https://github.com/mikisvaz/rubyinline.git

rm -Rf /usr/lib/ruby/gems/*/doc /usr/lib/ruby/gems/*/cache

grep rbbt_environment /etc/rbbt_environment || echo 'for f in $(rbbt find etc/environment -w all); do source "$f"; done' >> "/etc/rbbt_environment"
grep rbbt_environment /etc/profile || echo "source /etc/rbbt_environment" >> /etc/profile
